# DraggableImageForm
[ING]画像ファイルをドラッグ＆ドロップを利用したフォームなどのサンプル（iOS Sample Study: Swift）

表示画像のタップ時やUICollectionViewの選択時等の「処理のトリガーとなる部分でGestureRecognizerを活用」や「一覧表示→詳細遷移のタイミングでのカスタムトランジション」を織り交ぜて、入力画面や表示タイミングのポイントになる部分のUIに一工夫を加えてみた形にしてみました。

また、レシピを選んで選択状態にする部分に関しては、UILongTapGestureRecognizerをUICollectionViewに付与をした上で、UILongTapGestureRecognizer発動時に実行されるメソッド内でドラッグ＆ドロップで対象のレシピサムネイル画像をヒットエリアに持って行き選択をするような動きをする実装をしています。

### 実装機能一覧

本サンプル内で実装している機能の一覧は下記になります。

+ 現在月の表示を元に祝祭日と曜日付きの日付のボタン表示機能
+ UILongTapGestureRecognizerを使用したUICollectionViewCell内の画像をドラッグ＆ドロップで動かしてヒットエリア判定を利用した選択処理機能
+ SwiftyJSON & Alamofireを利用したAPI通信機能（楽天レシピカテゴリ別ランキングAPI使用）
+ APIから取得した画像表示時キャッシュ機能
+ Realmを使用した選択したレシピデータのアーカイブ保存機能
+ カスタムトランジションを利用したレシピ画像の拡大・縮小を伴う画面遷移機能
+ ContainerViewを重ねてスライド式メニューを表示する機能

### 本サンプルの画面キャプチャ

#### 画面キャプチャその1

![今回のサンプルの画面一覧その1](https://qiita-image-store.s3.amazonaws.com/0/17400/79cdeae5-4d1c-3b72-407a-9e9fbdd26926.jpeg)

#### 画面キャプチャその2

![今回のサンプルの画面一覧その2](https://qiita-image-store.s3.amazonaws.com/0/17400/deb95e6a-e26f-bb24-a04b-6027d824650f.jpeg)

#### 画面キャプチャその3

![今回のサンプルの画面一覧その3](https://qiita-image-store.s3.amazonaws.com/0/17400/e6495b31-1788-112e-752f-be200f38191f.jpeg)

### レシピを選択する画面での主な機能について

#### 1. MakeRecipeController.swiftでの各ボタンの役割

![ボタンの役割](https://qiita-image-store.s3.amazonaws.com/0/17400/7417e244-96d2-f471-27c2-714903831f23.jpeg)

#### 2. レシピ表示のUICollectionViewのセルを長押しした場合の動き

![選択時及び画像ドラッグ中の表示](https://qiita-image-store.s3.amazonaws.com/0/17400/364cf6f5-673f-1260-8cc9-033c571fb1a6.jpeg)

#### 3. 任意のレシピを選択した場合の表示

![レシピが選択状態になった際の表示](https://qiita-image-store.s3.amazonaws.com/0/17400/7628aa34-f81c-e7a9-81a5-a28b5e68d80d.jpeg)

#### レシピ選択画面におけるUIの操作概要

1. UIScrollViewに配置したボタンから対象の日付を日にちのボタンをタップして選択する
2. 「Add」ボタンを押すとUICollectionViewにAPIから取得したデータ4件が表示されます。また続けてタップボタンを押すとさらに別カテゴリのデータが4件表示されます（重複もありえる）
3. UICollectionViewの任意のセルを長押しすると選択した画像が指で動かせるようになるので、ヒットエリア（実体はUIButton）までドラッグして指を離すとそのレシピが選択状態になり、ヒットエリア以外で指を離すと選択状態にならずに画像表示が元に戻る
4. 日にちとレシピデータが選択されている状態でヒットエリアを押下すると、ポップアップが表示されレシピのアーカイブデータ登録フォームが表示される
5. 選択したデータを全て解除及びレシピ画像を一旦クリアする場合には「Reset」ボタンを押下すると選択データと表示レシピデータを削除する

### レシピ選択画面の他の部分における機能に関する設計図

本サンプルでの実装機能の中でポイントとなる部分の設計概要に関しては下記の図解を参考にしていただければ幸いです。

#### 1. Storyboard概略図

![Storyboard概略図](https://qiita-image-store.s3.amazonaws.com/0/17400/d9f6b15a-2b7c-1924-6e0d-b4a7e62a115b.jpeg)

#### 2. 楽天レシピカテゴリ別ランキングAPIからのデータ取得処理に関する概要

![楽天レシピカテゴリ別ランキングAPIからのデータ取得処理に関する概要](https://qiita-image-store.s3.amazonaws.com/0/17400/6df32919-3f4d-d1af-3866-1d672a8d141b.jpeg)

#### 3. Realmのカラム定義に関する概要

![Realmのカラム定義に関する概要](https://qiita-image-store.s3.amazonaws.com/0/17400/200ef4a9-0ec7-6dfd-a444-dab7456aa6de.jpeg)

#### 4. レシピ一覧画面から詳細画面へ遷移する際のカスタムトランジションに関する概要

![レシピ一覧画面から詳細画面へ遷移する際のカスタムトランジションに関する概要](https://qiita-image-store.s3.amazonaws.com/0/17400/cac6073b-10ef-a898-b8b5-f2b334183f5b.jpeg)

#### 5. ContainerViewの重なりとプロトコルを活用したメニュー開閉処理に関する概要

![ContainerViewの重なりとプロトコルを活用したメニュー開閉処理に関する概要](https://qiita-image-store.s3.amazonaws.com/0/17400/25b1ff3c-a22a-078e-a61f-516634cd5af0.jpeg)

### 使用ライブラリ

UIまわりの実装と直接関係のない部分に関しては、下記のライブラリを使用しました。

+ [RealmSwift（アプリ内のデータベース）](https://realm.io/jp/docs/)
+ [SwiftyJSON（JSONデータの解析をしやすくする）](https://github.com/SwiftyJSON/SwiftyJSON)
+ [Alamofire（HTTPないしはHTTPSのネットワーク通信用）](https://github.com/Alamofire/Alamofire)
+ [KingFisher（画像URLからの非同期での画像表示とキャッシュサポート）](https://github.com/onevcat/Kingfisher)
+ [CalculateCalendarLogic（日本の祝祭日の判定）](https://cocoapods.org/pods/CalculateCalendarLogic)

### 参考記事

下記の記事及びサンプルを参考にしてSwift3.0.2で書き直し及びアレンジを加えて本サンプルを作成しました。この場をお借り致しましてお礼申し上げます。ありがとうございました。

+ [UICollectionViewDragAndDropSelectedItems](https://github.com/keygx/UICollectionViewDragAndDropSelectedItems)
+ [iOS Animation Tutorial: Custom View Controller Presentation Transitions](https://www.raywenderlich.com/113845/ios-animation-tutorial-custom-view-controller-presentation-transitions)

このサンプル全体の詳細解説とポイントをまとめたものは下記に掲載しております。

+ (Qiita) http://qiita.com/fumiyasac@github/items/6c4c2b909a821932be04
