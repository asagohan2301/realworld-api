# RealWorld API

## 概要

ブログプラットフォームを作る [RealWorld](https://github.com/gothinkster/realworld/tree/main) という OSS のプロジェクトがあります。  
本リポジトリは、[RealWorld の バックエンドの API](https://realworld-docs.netlify.app/docs/specs/backend-specs/introduction) の仕様を Rails で作成したものです。

## 機能

### 実装済み

- ユーザー登録
- ログイン
- 記事の投稿、取得、更新、削除

### 未実装

- お気に入り

## API 設計

### 1. ユーザー

#### 1-1. ユーザーを登録する

エンドポイント：

```bash
POST http://localhost:3000/api/users
```

リクエストヘッダー：

**Content-Type**： application/json

リクエストボディ：

**username** `String`：ユーザー名  
**email** `String`：メールアドレス  
**password** `String`：パスワード

リクエストの例：

```json
{
  "user": {
    "username": "Jacob",
    "email": "jake@jake.jake",
    "password": "jakejake"
  }
}
```

レスポンス：

HTTP ステータスコード `201 Created` と、以下の情報を含む JSON オブジェクトを返します。

**username** `String`：登録されたユーザー名  
**email** `String`：登録されたメールアドレス

レスポンスの例：

```json
{
  "user": {
    "username": "Jacob",
    "email": "jake@jake.jake"
  }
}
```

エラーレスポンス：

バリデーションエラーの際は、HTTP ステータスコード `422 Unprocessable Entity` と、以下の情報を含む JSON オブジェクトを返します。

**errors** `Array<String>`：エラーメッセージの配列

エラーレスポンスの例：

```json
{
  "errors": ["Username can't be blank", "Email can't be blank"]
}
```

#### 1-2. ログインする (トークンを発行する)

登録済みのメールアドレスとパスワードでログインしてください。  
ログインに成功するとトークンが発行されます。

エンドポイント：

```bash
POST http://localhost:3000/api/users/login
```

リクエストヘッダー：

**Content-Type**： application/json

リクエストボディ：

**email** `String`：登録済みのメールアドレス  
**password** `String`：登録済みのパスワード

リクエストの例：

```json
{
  "user": {
    "email": "jake@jake.jake",
    "password": "jakejake"
  }
}
```

レスポンス：

HTTP ステータスコード `200 OK` と、以下の情報を含む JSON オブジェクトを返します。

**username** `String`：登録済みのユーザー名  
**email** `String`：登録済みのメールアドレス  
**token** `String`：発行されたトークン

レスポンスの例：

```json
{
  "user": {
    "username": "Jacob",
    "email": "jake@jake.jake",
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTJ9.SZqlT7WhQJiiNmzjttXvcVtVhUAd45ZkYZY2ZggiiKc"
  }
}
```

エラーレスポンス：

ログインに失敗した場合は、HTTP ステータスコード `401 Unauthorized` と、以下の情報を含む JSON オブジェクトを返します。

**errors** `Array<String>`：エラーメッセージの配列

エラーレスポンスの例：

```json
{
  "errors": ["Authentication failed"]
}
```

### 2. 記事

#### 2-1. 記事一覧を取得する

エンドポイント：

```bash
GET http://localhost:3000/api/articles
```

レスポンス：

HTTP ステータスコード `200 OK` と、以下の情報を含む JSON オブジェクトを返します。

**slug** `String`：記事のスラッグ  
**title** `String`：記事タイトル  
**description** `String`：記事概要  
**body** `Text`：記事本文  
**tag_list** `Array<String>`：記事のタグの配列  
**created_at** `DateTime`：記事が投稿された日時  
**updated_at** `DateTime`：記事が更新された日時  
**author** `Array<String>`：記事の投稿者情報  
**username** `Array<String>`：記事の投稿者名

レスポンスの例：

```json
{
  "articles": [
    {
      "slug": "how-to-train-your-dragon",
      "title": "How to train your dragon",
      "description": "Ever wonder how?",
      "body": "You have to believe",
      "tag_list": ["reactjs", "angularjs", "dragons"],
      "created_at": "2024-01-07T04:39:09.152Z",
      "updated_at": "2024-01-07T04:39:09.152Z",
      "author": {
        "username": "Jacob"
      }
    },
    {
      "slug": "how-to-train-your-dragon-2",
      "title": "How to train your dragon 2",
      "description": "So toothless",
      "body": "It a dragon",
      "tag_list": ["reactjs", "angularjs", "dragons"],
      "created_at": "2024-01-25T12:54:40.755Z",
      "updated_at": "2024-01-25T12:54:40.755Z",
      "author": {
        "username": "Jacob"
      }
    }
  ]
}
```

#### 2-2. 記事を投稿する

概要：

記事を投稿するにはユーザー認証が必要です。ログイン成功時に発行されたトークンをリクエストヘッダーに含めてください。

エンドポイント：

```bash
POST http://localhost:3000/api/articles
```

リクエストヘッダー：

**Content-Type**： application/json  
**Authorization**： Bearer <トークン>

リクエストボディ：

**title** `String`：記事タイトル  
**description** `String`：記事概要  
**body** `Text`：記事本文  
**tag_list** `Array<String>`：記事につけるタグの配列

リクエストの例：

```json
{
  "article": {
    "title": "How to train your dragon",
    "description": "Ever wonder how?",
    "body": "You have to believe",
    "tag_list": ["reactjs", "angularjs", "dragons"]
  }
}
```

レスポンス：

HTTP ステータスコード `201 Created` と、以下の情報を含む JSON オブジェクトを返します。

**slug** `String`：投稿された記事のスラッグ  
**title** `String`：投稿された記事タイトル  
**description** `String`：投稿された記事概要  
**body** `Text`：投稿された記事本文  
**tag_list** `Array<String>`：投稿された記事のタグの配列  
**created_at** `DateTime`：記事が投稿された日時  
**updated_at** `DateTime`：記事が更新された日時  
**author** `Array<String>`：記事の投稿者情報  
**username** `Array<String>`：記事の投稿者名

レスポンスの例：

```json
{
  "article": {
    "slug": "how-to-train-your-dragon",
    "title": "How to train your dragon",
    "description": "Ever wonder how?",
    "body": "You have to believe",
    "tag_list": ["reactjs", "angularjs", "dragons"],
    "created_at": "2024-01-07T04:39:09.152Z",
    "updated_at": "2024-01-07T04:39:09.152Z",
    "author": {
      "username": "Jacob"
    }
  }
}
```

エラーレスポンス：

ユーザー認証に失敗した場合は、HTTP ステータスコード `401 Unauthorized` と、以下の情報を含む JSON オブジェクトを返します。

**errors** `Array<String>`：エラーメッセージの配列

エラーレスポンスの例：

```json
{
  "errors": ["Invalid token or user not found"]
}
```

#### 2-3. 記事を取得する

エンドポイント：

```bash
GET http://localhost:3000/api/articles/:slug
```

パスパラメータ：

**slug**：取得する記事のスラッグ

レスポンス：

HTTP ステータスコード `200 OK` と、以下の情報を含む JSON オブジェクトを返します。

**slug** `String`：記事のスラッグ  
**title** `String`：記事タイトル  
**description** `String`：記事概要  
**body** `Text`：記事本文  
**tag_list** `Array<String>`：記事のタグの配列  
**created_at** `DateTime`：記事が投稿された日時  
**updated_at** `DateTime`：記事が更新された日時  
**author** `Array<String>`：記事の投稿者情報  
**username** `Array<String>`：記事の投稿者名

レスポンスの例：

```json
{
  "article": {
    "slug": "how-to-train-your-dragon",
    "title": "How to train your dragon",
    "description": "Ever wonder how?",
    "body": "You have to believe",
    "tag_list": ["reactjs", "angularjs", "dragons"],
    "created_at": "2024-01-07T04:39:09.152Z",
    "updated_at": "2024-01-07T04:39:09.152Z",
    "author": {
      "username": "Jacob"
    }
  }
}
```

エラーレスポンス：

記事が見つからなかった場合は、HTTP ステータスコード `404 Not Found` と、以下の情報を含む JSON オブジェクトを返します。

**errors** `Array<String>`：エラーメッセージの配列

エラーレスポンスの例：

```json
{
  "errors": ["Article not found"]
}
```

#### 2-4. 記事を更新する

概要：

記事を更新するにはユーザー認証が必要です。ログイン成功時に発行されたトークンをリクエストヘッダーに含めてください。  
また、記事の投稿者本人しか更新できません。

エンドポイント：

```bash
PUT http://localhost:3000/api/articles/:slug
```

パスパラメータ：

**slug**：更新する記事のスラッグ

リクエストヘッダー：

**Content-Type**： application/json  
**Authorization**： Bearer <トークン>

リクエストボディ：

以下のうち、更新したい項目をリクエストに含めてください。

**title** `String`：記事タイトル  
**description** `String`：記事概要  
**body** `Text`：記事本文  
**tag_list** `Array<String>`：記事につけるタグの配列

リクエストの例：

```json
{
  "article": {
    "body": "With two hands"
  }
}
```

レスポンス：

HTTP ステータスコード `200 OK` と、以下の情報を含む JSON オブジェクトを返します。

**slug** `String`：更新された記事のスラッグ  
**title** `String`：更新された記事タイトル  
**description** `String`：更新された記事概要  
**body** `Text`：更新された記事本文  
**tag_list** `Array<String>`：更新された記事のタグの配列  
**created_at** `DateTime`：記事が投稿された日時  
**updated_at** `DateTime`：記事が更新された日時  
**author** `Array<String>`：記事の投稿者情報  
**username** `Array<String>`：記事の投稿者名

レスポンスの例：

```json
{
  "article": {
    "slug": "how-to-train-your-dragon",
    "title": "How to train your dragon",
    "description": "Ever wonder how?",
    "body": "With two hands",
    "tag_list": ["reactjs", "angularjs", "dragons"],
    "created_at": "2024-01-07T04:39:09.152Z",
    "updated_at": "2024-01-07T05:20:46.744Z",
    "author": {
      "username": "Jacob"
    }
  }
}
```

エラーレスポンス：

- ユーザー認証に失敗した場合は、HTTP ステータスコード `401 Unauthorized` と、以下の情報を含む JSON オブジェクトを返します。
- 記事が見つからなかった場合は、HTTP ステータスコード `404 Not Found` と、以下の情報を含む JSON オブジェクトを返します。
- 記事の投稿者でない場合は、HTTP ステータスコード `403 Forbidden` と、以下の情報を含む JSON オブジェクトを返します。

**errors** `Array<String>`：エラーメッセージの配列

エラーレスポンスの例：

```json
{
  "errors": ["Invalid token or user not found"]
}
```

#### 2-5. 記事を削除する

概要：

記事を削除するにはユーザー認証が必要です。ログイン成功時に発行されたトークンをリクエストヘッダーに含めてください。  
また、記事の投稿者本人しか削除できません。

エンドポイント：

```bash
DELETE http://localhost:3000/api/articles/:slug
```

パスパラメータ：

**slug**：削除する記事のスラッグ

リクエストヘッダー：

**Authorization**： Bearer <トークン>

レスポンス：

HTTP ステータスコード `204 No Content` を返します。

エラーレスポンス：

- ユーザー認証に失敗した場合は、HTTP ステータスコード `401 Unauthorized` と、以下の情報を含む JSON オブジェクトを返します。
- 記事が見つからなかった場合は、HTTP ステータスコード `404 Not Found` と、以下の情報を含む JSON オブジェクトを返します。
- 記事の投稿者でない場合は、HTTP ステータスコード `403 Forbidden` と、以下の情報を含む JSON オブジェクトを返します。

**errors** `Array<String>`：エラーメッセージの配列

エラーレスポンスの例：

```json
{
  "errors": ["You are not authorized to perform this action"]
}
```
