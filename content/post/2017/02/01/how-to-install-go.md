+++
title = "Go のインストールと $GOPATH の設定"
draft = false
date = "2017-02-01T13:52:39+09:00"
categories = ["Go"]
tags = ["Go", "GOPATH", "GOROOT"]
thumbnailImage = "/images/2017/02/01/gopher.jpg"
thumbnailImagePosition = "right"
+++

## tl;dr

```sh
$ brew install go
```

`$GOPATH` はどこでもいいが `$HOME/go` が主流

`$GOROOT` は基本的に設定不要

## Go のインストール (macOS, Linux)

バイナリをインストールしましょう。

大きく分けると 3 つの方法があります。

- パッケージマネージャを利用
- 公式のバイナリリリースを利用
- バージョンマネージャを利用

### パッケージマネージャでインストール

おそらく最も簡単な方法です。

各 OS のパッケージマネージャでインストールします。

例えば macOS なら

```sh
$ brew install go
```

Debian 系なら

```sh
$ sudo apt-get install golang
```

となります。

ですが、パッケージのアップデートが遅いようで、 2017.02.01 現在では go1.6.1 がインストールされます。

```
$ apt show golang
Package: golang
Version: 2:1.6.1+1ubuntu2
Priority: optional
Section: devel
Source: golang-defaults
Origin: Ubuntu
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: Go Compiler Team <pkg-golang-devel@lists.alioth.debian.org>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Installed-Size: 10.2 kB
Depends: golang-1.6, golang-doc (>= 2:1.6.1+1ubuntu2), golang-go (>= 2:1.6.1+1ubuntu2), golang-src (>= 2:1.6.1+1ubuntu2)
Homepage: https://golang.org
Supported: 9m
Download-Size: 2812 B
APT-Sources: http://archive.ubuntu.com/ubuntu yakkety/main amd64 Packages
Description: Go programming language compiler - metapackage
```

最新の Go をインストールしたい場合は非公式リポジトリを探すか、公式のバイナリをダウンロードしましょう。

2017.02.01　だと以下のリポジトリで go1.7.3 をインストールできます。

```sh
$ sudo add-apt-repository ppa:tsuru/golang17
$ sudo apt-get install golang-1.7
```

### 公式のバイナリリリースからインストール

[Downloads - The Go Programming Language](https://golang.org/dl/) からバイナリをダウンロードします。

特に理由が無ければ tarball でいいでしょう。

ダウンロードが完了したら `/usr/local` に解凍します。

```sh
$ tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz
```

`$VERSION`, `$OS`, `$ARCH` はダウンロードしたものに合わせてください。

例えば macOS であれば次のようになるはずです。

```sh
$ tar -C /usr/local -xzf go1.7.5.darwin-amd64.tar.gz
```

解凍できたらパスを通します。

```sh
$ export PATH=$PATH:/usr/local/go/bin
```

ここでインストールの確認をしましょう。シェルで上記コマンドを入力し、 `go version` と打ちます。

```sh
go version go1.7.5 darwin/amd64
```

と表示されれば、インストールは成功しています。

最後に各シェルの設定ファイルにパスの設定を書いておきます。

```sh
$ echo 'export PATH=$PATH:/usr/local/go/bin' >> <path/to/profile>
$ echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc # => zsh の場合
```

以上でインストール完了です。

### バージョンマネージャでインストール

pyenv や rbenv のようなツールとして Go にもあります。

私は [syndbg/goenv](https://github.com/syndbg/goenv) を [riywo/anyenv](https://github.com/riywo/anyenv) 経由で利用しています。

（ riywo/anyenv のデフォルトの goenv は [kaneshin/goenv](https://github.com/kaneshin/goenv) です。この辺りは好みですね。）

goenv のインストールについては各ツールのドキュメントを見て下さい。

## Go のインストール (Windows)

[Downloads - The Go Programming Language](https://golang.org/dl/) から msi インストーラをダウンロードします。

インストーラを実行すると `c:\Go` に実行ファイルが配置されるようなので、`c:\Go\bin` を PATH に追加します。

## GOPATH について

Go は `$GOPATH` で設定されたディレクトリを作業ディレクトリとします。

また、パッケージのダウンロード先も `$GOPATH` 内となります。

ディレクトリの場所はどこでも良いですが、

`$HOME/go`, `$HOME/.go` が多いようです。

なお、 Go 1.8 からはデフォルトの `$GOPATH` が `$HOME/go` （ Windows では ` %USERPROFILE%/go` ） となるようです。

[go/build: implement default GOPATH](https://github.com/golang/go/commit/dc4a815d100b82643656ec88fd9fa8e7c705ebba)

自分で `$GOPATH` を設定する場合は、

```sh
$ echo 'export GOPATH=<path/to/GOPATH>' >> <path/to/profile>
```

でシェルの設定ファイルに書いておきましょう。

### GOROOT について

Go のインストールについての記事を Web で検索すると、 `$GOROOT` を設定する旨を書いた記事がよくあります。

しかし、現在は Go のバイナリに `$GOROOT` が埋め込まれているため、基本的には設定しなくても良いです。

設定が必要なケースの方は教えられなくても設定できるかと思います。

以上が基本的な Go のインストール方法です。
