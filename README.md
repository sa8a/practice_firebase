# Flutter x Firestore

- `FlutterFire CLI` でFirebaseプロジェクトの立ち上げと設定
- `Cloud Firestore` にデータ入力とデータ共有

## 参考サイト

- [公式ドキュメント](https://firebase.google.com/docs/flutter/setup?platform=ios)
- [【2022年最新】 Flutter × Firebase でアプリを作ろう！](https://blog.flutteruniv.com/flutter-firebase/)

## 注意点

GithubのリモートリポジトリにFirebase構成情報をアップロードしないために、プロジェクトルートの.gitignoreに以下2つを追記

```
# Firebase構成情報をアップロードしないため
google-services.json
GoogleService-Info.plist

# 以下独自判断で一応追加
firebase_app_id_file.json
firebase_options.dart
```
