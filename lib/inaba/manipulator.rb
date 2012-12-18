#!/usr/bin/env ruby
# encoding: utf-8

require "hakto/safe_sdbm"

# Inaba git like SDBM manipulator is a manipulator of SDBM database.
# Author::    Moza USANE (mailto:mozamimy@quellencode.org)
# Copyright:: Copyright (c) 2012 Moza USANE
# License::   MIT License (see the LICENSE file)
module Inaba

  # Manipulator of SDBM database.
  # It manipurates SDBM database by some sub commands.
  class Manipulator

    # Return codes
    ARG_ERROR = -1
    CMD_ERROR = -2
    ENV_ERROR = -3
    SUCCESS   =  0

    # Initialize Manipulator
    def initialize(argv)
      @argv = argv
      check_env
    end

    # Run Manipulator
    # ==== Return
    # ret_code :: Return code of Manipulator's process.
    def run
      COMMANDS.each do |cmd_group|
        cmd_group.each do |cmd|
          ret_code = self.send("operate_#{cmd_group[0]}", @argv) if @argv[0] == cmd
          return ret_code if (ret_code == ARG_ERROR or ret_code == SUCCESS)
        end
      end

      print_unrecognizable_error
      return CMD_ERROR
    end

    # Does Manipulator has a valid environment variable: $INABA_DB
    # ==== Return
    # is_ready :: ready status
    def ready?
      @is_ready
    end

    private
    ENV_STRING = "INABA_DB"

    COMMAND_ADD    = ["add", "a"]
    COMMAND_CLEAR  = ["clear", "c"]
    COMMAND_DEL    = ["del", "d"]
    COMMAND_LIST   = ["list", "l"]
    COMMAND_KEYS   = ["keys", "k"]
    COMMAND_VALUES = ["values", "v"]
    COMMAND_CSV    = ["csv", "s"]
    COMMAND_HELP   = ["help", "h"]
    COMMANDS = [COMMAND_ADD, COMMAND_DEL, COMMAND_LIST,
                COMMAND_KEYS, COMMAND_VALUES, COMMAND_CSV,
                COMMAND_HELP, COMMAND_CLEAR]

    def check_env
      if ENV[ENV_STRING]
        @dbm = Hakto::SafeSDBM.new(ENV[ENV_STRING])
        @is_ready = true
      else
        print_env_error_msg
        @is_ready = false
      end
    end

    def print_env_error_msg
      warn "**Environment variable error**"
      warn "Did you define $INABA_DB environment variable?"
      warn "Try following command if you use bash."
      warn 'export INABA_DB="[your_db_file_path]"'
    end

    def print_unrecognizable_error
      warn "**Unrecognizable command '#{@argv[0]}'"
      operate_help(nil)
    end

    def operate_add(cmd_line)
      operate(cmd_line, 3) do
        @dbm[cmd_line[1]] = cmd_line[2]
      end
    end

    def operate_clear(cmd_line)
      operate(cmd_line, 1) {@dbm.clear}
    end

    def operate_del(cmd_line)
      operate(cmd_line, 2) {@dbm.delete(cmd_line[1])}
    end

    def operate_list(cmd_line)
      operate(cmd_line, 1) {@dbm.print_each}
    end

    def operate_keys(cmd_line)
      operate(cmd_line, 1) {@dbm.print_keys; print "\n"}
    end

    def operate_values(cmd_line)
      operate(cmd_line, 1) {@dbm.print_values; print "\n"}
    end

    def operate_csv(cmd_line)
      operate(cmd_line, 1) {print @dbm.csv_each}
    end

    def operate_help(cmd_line)
      puts "[command]        [description]"
      puts "add key value :: Add a key-value pair"
      puts "del key       :: Delete value on key"
      puts "list          :: Print all key-value pairs"
      puts "keys          :: Print all keys"
      puts "values        :: Print all values"
      puts "csv           :: Print all values as CSV format"
      puts "help          :: Print this help"
      return SUCCESS
    end

    def operate(cmd, cmd_length, &block)
      if cmd.length == cmd_length
        yield
        return SUCCESS
      else
        print_argument_error(cmd)
        return ARG_ERROR
      end
    end

    def print_argument_error(cmd)
      warn "**Command's argument is invalid"
      warn "in #{cmd[0]} command."
    end
  end
end
