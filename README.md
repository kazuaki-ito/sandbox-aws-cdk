# AWS-CDKのSandbox環境

## 環境要件

* Docker
* docker-compose
* git

## 環境の起動

```
git clone git@github.com:kazuaki-ito/sandbox-aws-cdk.git
```

```shell script
# 環境起動
docker-compose up -d

# 少し待ってから
docker-compose ps 

# コンテナのステータスがUPになってからbash起動
docker-compose exec cdk bash
```

## 初期設定

※コンテナのbashを起動してから

```shell script
# クレデンシャルの設定
aws configure
```