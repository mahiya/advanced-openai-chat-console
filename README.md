# Azure OpenAI Service Chat API のクライアント

## 使い方

```openai_settings.json``` のプロパティ ```OPENAI_NAME``` に使用する Azure OpenAI Service のアカウント名を、プロパティ ```OPENAI_KEY``` に認証キーを、```OPENAI_MODEL``` に使用するモデルのデプロイメント名を指定します。

## ローカル環境での実行方法

以下のコマンドを実行して Python モジュールをインストールします。
```bash
pip install -r requirements.txt
```

以下の通りに ```localrun.sh``` を実行して、Web アプリケーションを起動します。
```bash
./localrun.sh
```

```http://127.0.0.1:5000``` を Web ブラウザで開くことで、アプリケーションを利用することができます。

![画面イメージ](.images/screenshot.png)

## Azure へのデプロイ方法

以下の通りに ```deploy.sh``` を実行して、Web アプリケーションを Azure へデプロイします。第一引数にはデプロイ先のリソースグループ名を指定する必要があります。
```bash
./deploy.sh {デプロイ先のリソースグループ名}
# [例] ./deploy.sh rg-simple-aoi-console
```
