+++
title = "Gogland の GOROOT に Finder で表示されないフォルダを設定する"
draft = false
date = "2016-12-24T03:59:26+09:00"
categories = ["Gogland"]
tags = ["Go", "Gogland", "GOROOT"]
thumbnailImage = "/images/2016/12/24/gogland-splash.png"
thumbnailImagePosition = "right"
+++

JetBrains 製の新しい Go IDE 、 Gogland の Early Access Program のお知らせが届きました。

![gogland eap mail](/images/2016/12/24/gogland-eap-mail.png)

早速使用してみましたが、 Go SDK を選ぶところで詰まってしまいました。

[公式ドキュメント](https://www.jetbrains.com/help/go/1.0/getting-started-with-gogland.html#setting_up_sdk)によれば、この Go SDK には `GOROOT` を設定すれば良いようですが、私は anyenv, goenv を使って Go の管理をしているため `GOROOT` が隠しフォルダに含まれます。

```sh
$ echo $GOROOT
/Users/tamrin/.anyenv/envs/goenv/versions/1.7.4
```

`GOROOT` を選択するインタフェースに `/Users/tamrin/.anyenv` が表示されないため、このままでは `GOROOT` を選ぶことができません。`

![GOROOT を見つけることができない](/images/2016/12/24/interface.png)

## 方法 1. 隠しフォルダを表示する

`Command + Shift + Period` で隠しフォルダ・ファイルが表示されるようになります。

![隠しフォルダを表示する](/images/2016/12/24/show-hidden-folders.png)

## 方法 2. パスを入力して移動する

`Command + Shift + G` でパスを直接入力して移動することができます。

![パスを入力して移動する](/images/2016/12/24/go-to-the-folder.png)

## 方法 3. 設定ファイルを配置する

Gogland でプロジェクトの `GOROOT` を設定すると `path/to/project/.idea/libraries` に Go SDK の設定ファイル `Go_SDK.xml` が作成されるようです。

![プロジェクトディレクトリに Go_SDK.xml がある](/images/2016/12/24/go-sdk-xml.png)

```xml:Go_SDK.xml
<component name="libraryTable">
  <library name="Go SDK">
    <CLASSES>
      <root url="file://$USER_HOME$/.anyenv/envs/goenv/versions/1.7.4/src" />
    </CLASSES>
    <SOURCES>
      <root url="file://$USER_HOME$/.anyenv/envs/goenv/versions/1.7.4/src" />
    </SOURCES>
  </library>
</component>
```

よって、この `Go_SDK.xml` 内の `<CLASSES>` と `SOURCES` を任意の `GOROOT` に変更すれば良いようです。

## Hello, world できた

以上の方法で、無事に Gogland で Hello, world することができました。

![Gogland で Hello, world](/images/2016/12/24/hello-world.png)
