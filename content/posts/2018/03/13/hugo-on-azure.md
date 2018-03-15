---
title: "Azure で静的サイトを公開するときにやること"
date: 2018-03-13T22:36:21+09:00
draft: false
tags: ["Azure", "Azure App Services", "Azure CDN", "Hugo"]
cover: /images/2018/03/13/structure.png
---

こんにちは、Tamrin007 です。

このブログを公開するにあたって Microsoft Azure を利用したのでその手順や方法について書いていきます。

## Hugo について

まずはじめに、このブログは静的サイトとして作成しています。つまりデータベース等から記事を取得しているわけではなく、ローカルの Markdown ファイルを変換して静的な HTML ファイルを書き出しています。

利用しているのは Go 製の [Hugo](https://gohugo.io) という静的サイトジェネレータです。

[The world’s fastest framework for building websites | Hugo](https://gohugo.io)

今回は、

- Go 標準のテンプレートエンジンが利用されているので、Go の経験が活かせる
- 記事のビルド（HTML ファイルの生成）が高速
- クロスプラットフォームで動作するのでマシンを変えてもすぐに移行できる

といった特長から採用しました。（後ろの 2 つは Go の利点と合致しますね）

Hugo についてはここでは割愛しますので、インストール方法などは上記の公式サイトをご覧ください。

## Azure での静的サイトのホスティング

今回は Microsoft のクラウドサービス Azure を利用します。こちらは特に明確な理由があるわけではなく

**将来的に仕事で Azure に関わる可能性が高く、慣れておくため**

ぐらいの理由です。

（経験で言うと AWS や GCP、手軽さで言うと GitHub Pages や Netlify の方が…モニョモニョ）

Azure で静的サイトをホスティングする方法は主に以下の 2 通りのようです。

- Azure Blob Storage を利用する
    - + Azure Functions を利用する
- Azure Web Apps を利用する

それぞれについて見ていきましょう。

### Azure Blob Storage

こちらは Azure のオブジェクトストレージです。AWS で言うと S3 ですね。

基本機能はその名の通り「ストレージ」ですが、配置されたコンテンツへの HTTP アクセスを用意しているようです。

こちらのドキュメントに詳しく記載されています。

[静的コンテンツ ホスティング | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/architecture/patterns/static-content-hosting)

コストがかなり抑えられる一方、不便な点もいくつかあるようで、こんな記事があります。

[Azure BlobでのWebサイト公開がつらい - Qiita](https://qiita.com/mentholnodoame/items/eae88fbd9cf409429f98)

### Azure App Service の Web Apps

こちらは Web アプリケーションをホストするためのサービスで、静的コンテンツのホスティングも提供されています。

元が Web アプリケーション用のサービスということもあり、CI/CD 機能なども統合されています。

Blob Storage よりも使い勝手が良さそうなので、今回はこちらを採用しました。

（実際に上記 [Qiita 記事](https://qiita.com/mentholnodoame/items/eae88fbd9cf409429f98)の問題は解決されます）

実際の構築手順は公式のチュートリアルがあります。

[Azure で静的な HTML Web アプリを作成する | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/app-service/app-service-web-get-started-html)

ただしこのチュートリアルでは Azure CLI というツールを使用しているため、少しハードルが高い…という方のために、簡単に Azure Portal での操作方法も記載しておきます。

1. [Azure Portal](https://portal.azure.com) にアクセス
1. [リソースの作成] をクリック
1. [Web App] を探してクリック
1. [アプリ名]、[リソースグループ]、[プラン]、[OS] を入力・選択
    - プランは F1 を選ぶと 0 円で利用できます
    - Linux を選ぶとインデックスページの問題が発生するようです、パフォーマンスの上でも Windows を選んだほうが利点が多いでしょう
1. しばらくするとダッシュボードに作成したリソースが表示されます

リソース作成の参考画像

![リソース作成の参考画像](/images/2018/03/13/app-service-plan.png "リソース作成の参考画像")

### Azure Web Apps に HTML をアップロードする

まずは簡単に始めるために、 FTPS を利用します。（GitHub 連携などができる方はやっちゃっていいです）

1. App Service の画面で [デプロイ資格情報]にアクセス
1. [FTP/デプロイ ユーザー名]、[パスワード]を入力
1. [概要] にアクセスし、表示されている FTPS の URL を確認
1. 適当な FTPS クライアントでアクセスし、`D:\home\site\wwwroot` というパスに HTML ファイルをアップロード
    - 私は [Cyberduck](https://cyberduck.io/) を使用しました
1. [概要] に記載されている自サイトの URL へアクセスし、確認

以上です。

## Web Apps にカスタムドメインを割り当て、HTTPS でアクセスできるようにする

D1 Shared プランであればカスタムドメインが、B1 以上であれば SSL サポートが利用できますが、費用がそれなりに嵩みます。

そこで今回は Azure CDN を利用し、カスタムドメインの割り当てと HTTPS でのアクセスを可能にします。

### Azure CDN

CDN は静的な Web コンテンツをキャッシュし、ユーザーへのコンテンツ配信を早め、Web サーバーの負荷を低減させることもできる仕組みです。

App Service との組み合わせ方はこちらのチュートリアルが参考になります。

[Azure App Service に CDN を追加する | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/app-service/app-service-web-tutorial-content-delivery-network)

**ただし、プランに注意してください**

Standard Akamai では [カスタム ドメイン HTTPS] が利用できません。

また、Standard Verizon では [キャッシュ/ヘッダーの設定 ( ルール エンジンを使用)] が利用できず、HTTP アクセスの HTTPS への書き換えなどができなくなります。

利用したい場合は Premium Verizon を選んでください。

[Azure CDN の概要 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cdn/cdn-overview#azure-cdn-features)

### Azure CDN にカスタムドメインを割り当て、HTTPS を有効にする

こちらもチュートリアルがあります。（公式チュートリアルが優秀ですね）

[カスタム ドメインを CDN エンドポイントに追加する | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cdn/cdn-map-content-to-custom-domain)

[Azure Content Delivery Network のカスタム ドメインで HTTPS を構成する | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cdn/cdn-custom-ssl)

**HTTPS を有効にする際はメールを受け取れるか注意してください**

HTTPS を有効にすると DigiCert という認証局から Whois 情報に載っているメールアドレスと、以下のメールアドレス宛に所有確認のメールが来ます。

- admin@\<custom-domain>
- administrator@\<custom-domain>
- webmaster@\<custom-domain>
- hostmaster@\<custom-domain>
- postmaster@\<custom-domain>

転送設定をするなど、確実に受け取れるようにしましょう。

メールを受け取ったらフォームの指示に従い認証を行います。しばらくすると晴れて HTTPS でアクセスできるようになります。

### Azure CDN のルールを設定する

Premium Verizon を選んでいる場合は [エンドポイント] の [高度な機能]、[管理] とアクセスすることで CDN のルールを設定できます。

例えば HTTP によるアクセスを HTTPS にリダイレクトしたい場合は、次のように設定します。

![HTTPS へのリダイレクトルール](/images/2018/03/13/redirect-rule.png "HTTPS へのリダイレクトルール")

- Source: (.*)
- Destination: https://%{host}/$1

これで常時 HTTPS でアクセスできるようになっているはずです。

## まとめ

今回の構成をまとめると以下になります。

![構成図](/images/2018/03/13/structure.png "構成図")

次回は GitHub を用いた継続的デプロイについて書こうと思います。
