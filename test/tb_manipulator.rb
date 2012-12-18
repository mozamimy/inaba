#!/usr/bin/env ruby
# encoding: utf-8

require "test/unit"
require "ariete"
require "stringio"
require_relative "../lib/inaba/manipulator"

include Inaba
include Ariete

# Notice:
# Set $INABA_DB environment variable before running this test.
# $ export INABA_DB="your_db_file_path"
class ManipulatorTest < Test::Unit::TestCase

  def setup
    @mnp = Manipulator.new("dummy")
  end

  def test_add
    add_common(["add", "rabbit", "RABBIT"])
  end

  def test_add_abbr
    add_common(["a", "rabbit", "RABBIT"])
  end

  def test_del
    del_common(["del", "rabbit"])
  end

  def test_del_abbr
    del_common(["d", "rabbit"])
  end

  def test_clear
    clear_common(["clear"])
  end

  def test_clear_abbr
    clear_common(["c"])
  end

  def test_list
    list_common(["list"])
  end

  def test_list_abbr
    list_common(["l"])
  end

  def test_keys
    keys_common(["keys"])
  end

  def test_keys_abbr
    keys_common(["k"])
  end

  def test_values
    values_common(["values"])
  end

  def test_values_abbr
    values_common(["v"])
  end

  def test_csv
    csv_common(["csv"])
  end

  def test_csv_abbr
    csv_common(["s"])
  end

  def test_help
    help_common(["help"])
  end

  def test_help_abbr
    help_common(["h"])
  end

  def test_arg_error
    argv = ["add", "invalid"]
    @mnp.instance_variable_set(:@argv, argv)
    ret_code = @mnp.run
    assert_equal(Manipulator::ARG_ERROR, ret_code)
  end

  def test_cmd_error
    argv = ["invalid", "rabbit", "pyonpyon"]
    @mnp.instance_variable_set(:@argv, argv)
    ret_code = @mnp.run
    assert_equal(Manipulator::CMD_ERROR, ret_code)
  end

  def teardown
    dbm = @mnp.instance_variable_get(:@dbm)
    dbm.clear
  end

  # common methods

  def add_common(argv)
    @mnp.instance_variable_set(:@argv, argv)

    ret_code = @mnp.run
    dbm = @mnp.instance_variable_get(:@dbm)
    assert_equal("RABBIT", dbm["rabbit"])
    assert_equal(Manipulator::SUCCESS, ret_code)
  end

  def del_common(argv)
    @mnp.instance_variable_set(:@argv, argv)
    dbm = @mnp.instance_variable_get(:@dbm)
    add_some_pair(dbm)

    ret_code = @mnp.run
    assert_equal(2, dbm.size)
    assert_equal(Manipulator::SUCCESS, ret_code)
    assert_nil(dbm["rabbit"])
    assert_equal("INABA", dbm["inaba"])
    assert_equal("HAKTO", dbm["hakto"])
  end

  def clear_common(argv)
    @mnp.instance_variable_set(:@argv, argv)
    dbm = @mnp.instance_variable_get(:@dbm)
    add_some_pair(dbm)

    ret_code = @mnp.run
    assert_equal(0, dbm.size)
    assert_nil(dbm["rabbit"])
    assert_nil(dbm["hakto"])
    assert_nil(dbm["inaba"])
  end

  def list_common(argv)
    @mnp.instance_variable_set(:@argv, argv)
    dbm = @mnp.instance_variable_get(:@dbm)
    add_some_pair(dbm)

    result = capture_stdout {@mnp.run}
    assert_equal("[rabbit]:RABBIT\n[hakto]:HAKTO\n[inaba]:INABA\n", result)
  end

  def keys_common(argv)
    @mnp.instance_variable_set(:@argv, argv)
    dbm = @mnp.instance_variable_get(:@dbm)
    add_some_pair(dbm)

    result = capture_stdout {@mnp.run}
    assert_equal("rabbit, hakto, inaba, \n", result)
  end

  def values_common(argv)
    @mnp.instance_variable_set(:@argv, argv)
    dbm = @mnp.instance_variable_get(:@dbm)
    add_some_pair(dbm)

    result = capture_stdout {@mnp.run}
    assert_equal("RABBIT, HAKTO, INABA, \n", result)
  end

  def csv_common(argv)
    @mnp.instance_variable_set(:@argv, argv)
    dbm = @mnp.instance_variable_get(:@dbm)
    add_some_pair(dbm)

    result = capture_stdout {@mnp.run}
    assert_equal("rabbit,RABBIT\r\nhakto,HAKTO\r\ninaba,INABA\r\n", result)
  end

  def help_common(argv)
    @mnp.instance_variable_set(:@argv, argv)
    result = capture_stdout {@mnp.run}
    assert_equal(result, put_help_string)
  end

  def add_some_pair(dbm)
    dbm["rabbit"] = "RABBIT"
    dbm["hakto"] = "HAKTO"
    dbm["inaba"] = "INABA"
  end

  def put_help_string
    str_io = StringIO.new
    str_io.puts "[command]        [description]"
    str_io.puts "add key value :: Add a key-value pair"
    str_io.puts "del key       :: Delete value on key"
    str_io.puts "list          :: Print all key-value pairs"
    str_io.puts "keys          :: Print all keys"
    str_io.puts "values        :: Print all values"
    str_io.puts "csv           :: Print all values as CSV format"
    str_io.puts "help          :: Print this help"
    str_io.string
  end

end
