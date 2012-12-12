Inaba SDBM Manipulator
======================

## イントロダクション

Inaba SDBM Manipulatorは、SDBMの内容を操作するためのコマンドラインツールである。キーバリューペアの追加、削除、一覧など、基本的なインターフェースを取り揃えている。

## 動作環境

以下の環境で開発およびテストをしている。

- Linux（openSUSE 12.2）・Mac OS X 10.8.2
- Ruby 1.9.3

## 構成

- **bin**
  - **inaba** :: 実行スクリプト
- **doc** :: rdocによるドキュメント
- **lib**
  - **inaba**
    - **manipulator.rb** :: Manipulatorクラス
- **Rakefile** :: gemパッケージ生成用のRakefile
- **test**
  - **tb_manipulator.rb** :: Manipulatorのテスト
  
## 依存ライブラリ

- [Hakto SDBM Safe Wrapper](http://blog.quellencode.org/post/37391766923/ruby-hakto-safe-sdbm-wrapper)
- [Ariete STDOUT & STDERR Capture Module](http://blog.quellencode.org/post/37625422082/ariete-stdout-stderr-capture-module)

## インストール

inaba-x.y.z.gemファイル（x、y、zはバージョン番号）をダウンロードし、以下のコマンドを入力してインストールする。

`$ sudo gem install inaba-x.y.z.gem`

または、RubyGems.orgからgemコマンドを使ってインストールすることもできる。

`$ sudo gem install inaba`

## チュートリアル

### 環境変数の設定

ファイル名入力の手間を省くために、環境変数INABA_DBにファイル名をセットする。対象のDBファイルがrabbit.sdbであれば、bashでは以下のように設定する。

`$ export INABA_DB="rabbit.sdb"`

### キーバリューペアを追加する

キーに値を追加するにはaddコマンドを使う。これで、キーrabbitに値RABBITがセットされる。

`$ inaba add rabbit RABBIT`

キーバリューペアの一覧を見るには、listコマンドを使う。

`$ inaba list`

    [rabbit]:RABBIT
    
もっとキーバリューペアを追加してみよう。

`$ inaba add bunny BUNNY`

`$ inaba add hare HARE`

`$ inaba list`

    [rabbit]:RABBIT
    [bunny]:BUNNY
    [hare]:HARE
    
CSV形式で出力することもできる。

`$ inaba csv`

    rabbit,RABBIT
    bunny,BUNNY
    hare,HARE
    
キーのみを一覧することもできる。

`$ inaba key`

    rabbit, bunny, hare,
    
値のみを一覧することもできる

`$ inaba values`

    RABBIT, BUNNY, HARE,
    
キーバリューペアの削除にはdelコマンドを使う。

`$ inaba del rabbit`

`$ inaba list`

    [bunny]:BUNNY
    [hare]:HARE
    
全て削除するためにはclearコマンドを使う。

`$ inaba clear`     

## コマンド一覧

|コマンド  |引数         |説明                               |
|----------|-------------|-----------------------------------|
|**add**   |*key* *value*|*key*に*value*を追加する           |
|**del**   |*key*        |*key*に関連付けられた値を削除する  |
|**list**  |             |キーバリューペアの一覧を出力する   |
|**keys**  |             |キー一覧を出力する                 |
|**values**|             |値一覧を出力する                   |
|**csv**   |             |キーバリューペアをCSV形式で出力する|
|**help**  |             |コマンド一覧を出力する             |

## ライセンス

本ソフトウェアは、MIT Licenseのもとで配布されている。詳細はLICENSEファイルに記している。

## 作者について

Moza USANE  
[http://blog.quellencode.org/](http://blog.quellencode.org/ "")  
mozamimy@quellencode.org