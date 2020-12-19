# AWS-CDKのSandbox環境 (2020年12月時点)

## はじめに

cdk + typescript でs3のバケットを作成するプラクティスを含むSandbox環境です。

cdk、aws-cliを動かす環境はdockerで用意しました。


## 環境準備
### 1. 環境要件 & 前提知識

* 環境要件
  * Docker
  * docker-compose
  * git
* 前提知識
  * docker-composeが使えること
  * gitが使えること
  * aws s3が何のサービスか知っていること
  * aws コンソール(web)の最低限の使い方がわかること

### 2. 事前に準備しておくこと

* AWS アカウント
  * 作業用のIAMユーザーも作成しておく。(プラクティスなのでAdministratorAccessの権限つけた状態で)

### 3. 初期設定

※ ホスト上での作業
```
# ソースの取得
$ git clone git@github.com:kazuaki-ito/sandbox-aws-cdk.git
```

```shell script
$ # 環境起動
$ docker-compose up -d

$ # 少し待ってから
$ docker-compose ps 

$ # コンテナのステータスがUPになってからbash起動
$ docker-compose exec cdk bash
```

※コンテナで起動したbash上での作業

```shell script
$ # クレデンシャルの設定
$ aws configure
AWS Access Key ID [None]: $アクセスキー}
AWS Secret Access Key [None]: ${シークレットアクセスキー} 
Default region name [None]: ap-northeast-1
Default output format [None]: json
```
* 参考
  * https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-quickstart.html

## CDK(TypeScript版)事始め(ここからプラクティス)

### 1. 環境の起動

※ ホスト上での作業
```shell script
$ # 環境起動
$ docker-compose up -d

$ # 少し待ってから
$ docker-compose ps 

$ # コンテナのステータスがUPになってからbash起動
$ docker-compose exec cdk bash
```

### 2. cdk appを作成する

※コンテナで起動したbash上での作業

```shell script
$ # 作業ディレクトリを作成
$ mkdir practice
$ cd practice

$ #cdk の初期設定
$ cdk bootstrap

$ # cdk appの初期化
$ cdk init app --language=typescript
```

### 3. s3のバケットを作成するスタックを作る

※コンテナで起動したbash上での作業(practiceディレクトリ)

```shell script

$ # s3を作成するためのライブラリをインストール
$ yarn add @aws-cdk/aws-s3

```

practice/lib/practice-stack.tsを以下の用に記述(これはホストから書き換えてもOK)
```typescript
import * as cdk from '@aws-cdk/core'
import * as s3 from '@aws-cdk/aws-s3'

export class PracticeStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const bucketName = 'xxxxx-sandbox-aws-cdk' // ← ここの値は適当な値に変更する
    new s3.Bucket(this, 'practice', {
      bucketName: bucketName,
      removalPolicy: cdk.RemovalPolicy.DESTROY
    })
  }
}
```

※コンテナで起動したbash上での作業(practiceディレクトリ)
```shell script
$ # appをビルド
$ yarn build

$ # AWSの環境と、作成しようとしているリソースの差分を表示
$ cdk diff

$ # おもむろにデプロイしてみる
$ cdk deploy

$ # 成功すればAWS コンソール上からs3 のバケットが作成されていることが確認できる
```

### 4. 後片付け

※コンテナで起動したbash上での作業(practiceディレクトリ)
```shell script

$ # 後片付け(作成したバケット削除) ※バケットの中が空じゃないと消せないので注意
$ cdk destroy
Are you sure you want to delete: PracticeStack (y/n)? y

$ # 成功すればAWS コンソール上からs3 のバケットが削除されていることが確認できる

```
