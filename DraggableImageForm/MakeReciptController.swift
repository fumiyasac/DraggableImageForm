//
//  MakeReciptController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/06.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

//選択用レシピ表示＆登録用のレシピ最大数に関する定義
struct RecipeSetting {
    static let recipeMaxCount = 20
}

//月間カレンダーの大きさに関する定義
struct CalenderSetting {
    static let areaRect     = 58
    static let centerPos    = 29
    static let buttonRect   = 46
    static let buttonRadius = 23
}

//メッセージエリアに表示する文言に関する定義
struct MessageSetting {

    //現在の年・月を表示する
    static func getDisplayYearAndMonth() -> String {
        return "現在月："
            + String(CalendarView.getCalendarOfCurrentYear()) + "年"
            + String(CalendarView.getCalendarOfCurrentMonth()) + "月"
    }

    //選択をした日付を表示する
    static func getSelectedDateMessage(day: Int) -> String {
        return "選択日："
            + String(CalendarView.getCalendarOfCurrentYear()) + "年"
            + String(CalendarView.getCalendarOfCurrentMonth()) + "月"
            + String(day) + "日"
    }
    
    //データをクリアした際の文言を表示する
    static func getClearDateMessage() -> String {
        return "該当日付を選択して下さい"
    }

    //レシピ選択時の文言を表示する
    static func getCountRecipeMessage(count: Int) -> String {
        let targetCount = RecipeSetting.recipeMaxCount - count
        if targetCount == 0 {
            return "レシピ登録は20点までです"
        }
        return "現在" + String(count) + "点選択中"
    }

    //データをクリアした際の文言を表示する
    static func getClearRecipeMessage() -> String {
        return "レシピ登録は20点までです"
    }
}

class MakeReciptController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //ドラッグ可能なイメージビュー
    var draggableImageView: UIImageView!
    
    //選択状態の判定用のフラグ
    var isSelectedFlag: Bool = false

    //スクロールビュー内のボタンを一度だけ生成するフラグ
    fileprivate var layoutOnceFlag: Bool = false
    
    //データ格納用の配列
    var selectedDataList: [(id: String, indication: String, published: String, title: String, image: String, url: String)] = []
    
    //APIから取得したデータを格納する配列
    var apiDataList: [(id: String, indication: String, published: String, title: String, image: String, url: String)] = []
    
    //選択された日を設定する
    var targetDay: Int? = nil
    
    //MakeReciptControllerクラス内のUIパーツ
    @IBOutlet weak var calendarScrollView: UIScrollView!
    @IBOutlet weak var receiptCollectionView: UICollectionView!
    @IBOutlet weak var dragAreaButton: UIButton!
    @IBOutlet weak var selectDataDisplayArea: UIView!
    
    //ステータス表示エリア内のUIパーツ
    @IBOutlet weak var currentYearAndMonthLabel: UILabel!
    @IBOutlet weak var selectedDayLabel: UILabel!
    @IBOutlet weak var selectedRecipeCountLabel: UILabel!
    @IBOutlet weak var reloadDataButton: UIButton!
    @IBOutlet weak var resetDataButton: UIButton!

    //メニューボタンの属性値
    let attrsButton = [
        NSForegroundColorAttributeName : UIColor.gray,
        NSFontAttributeName : UIFont(name: "Georgia", size: 14)!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        //CollectionViewのデリゲート/データソース
        receiptCollectionView.delegate = self
        receiptCollectionView.dataSource = self
        
        //NavigationControllerに関する設定（タイトル・左右メニュー）
        navigationItem.title = "直感レシピ"

        let leftMenuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(MakeReciptController.reloadButtonTapped(button:)))
        leftMenuButton.setTitleTextAttributes(attrsButton, for: .normal)
        navigationItem.leftBarButtonItem = leftMenuButton

        let rightMenuButton = UIBarButtonItem(title: "Archive", style: .plain, target: self, action: #selector(MakeReciptController.archiveButtonTapped(button:)))
        rightMenuButton.setTitleTextAttributes(attrsButton, for: .normal)
        navigationItem.rightBarButtonItem = rightMenuButton

        //配置したUIパーツに対するターゲットや初期設定
        initDefaultUiSetting()
        initTargetMessageSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //レイアウト処理が完了した際のライフサイクル
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //UIScrollViewへのボタン配置を行う ※AutoLayoutのConstraintを用いたアニメーションの際には動的に配置する見た目要素は一度だけ実行する
        if layoutOnceFlag == false {
            
            //コンテンツ用のScrollViewを初期化
            initScrollViewDefinition()

            //カレンダーボタンのリストを取得する
            let targetButtonList: [UIButton] = CalendarView.getCalendarOfCurrentButtonList()
            
            //スクロールビュー内のサイズを決定する（AutoLayoutで配置を行った場合でもこの部分はコードで設定しないといけない）
            calendarScrollView.contentSize = CGSize(
                width: CGFloat(CalenderSetting.areaRect * targetButtonList.count),
                height: calendarScrollView.frame.height
            )
            
            //カレンダーのスクロールビュー内にボタンを配置する
            for i in 0...(targetButtonList.count - 1) {
                
                //メニュー用のスクロールビューにボタンを配置
                calendarScrollView.addSubview(targetButtonList[i])

                //サイズの決定
                targetButtonList[i].frame.size = CGSize(
                    width: CalenderSetting.buttonRect,
                    height: CalenderSetting.buttonRect
                )

                //中心位置の決定
                targetButtonList[i].center = CGPoint(
                    x: CalenderSetting.centerPos + CalenderSetting.areaRect * i,
                    y: CalenderSetting.centerPos
                )

                //装飾とターゲットの決定
                targetButtonList[i].layer.cornerRadius = CGFloat(CalenderSetting.buttonRadius)
                targetButtonList[i].addTarget(self, action: #selector(MakeReciptController.calendarButtonTapped(button:)), for: .touchUpInside)
            }
            
            //一度だけ実行するフラグを有効化
            layoutOnceFlag = true
        }
    }
    
    /* (Instance Methods) */

    //カレンダーのボタンを押した時のアクション
    func calendarButtonTapped(button: UIButton) {
        targetDay = button.tag
        selectedDayLabel.text = MessageSetting.getSelectedDateMessage(day: button.tag)
    }
    
    //Reloadボタンを押した時のアクション
    func reloadButtonTapped(button: UIButton) {
        loadApiData(categoryId: CategoryList.fetchTargetCategory())
    }

    //Resetボタンを押した時のアクション
    func resetButtonTapped(button: UIButton) {
        initTargetMessageSetting()
    }
    
    //現在データのハンドリングを行うアクション
    func handleButtonTapped(button: UIButton) {
        print("Handle button tapped.")
    }

    //Archiveボタンを押した時のアクション
    func archiveButtonTapped(button: UIButton) {
        print("Archive button tapped.")
    }

    //セルを長押しした際(UILongPressGestureRecognizerで実行された際)に発動する処理
    func longPressCell(sender: UILongPressGestureRecognizer) {

        //長押ししたセルのタグ名と現在位置を設定する
        let targetTag: Int = (sender.view?.tag)!
        let pressPoint: CGPoint = sender.location(ofTouch: 0, in: self.view)

        //タグの値(=indexPath.row)の値を元にデータを抽出する
        let selectedData: (id: String, indication: String, published: String, title: String, image: String, url: String) = apiDataList[targetTag]
        
        //対象の画像サイズと中心位置を算出する
        let targetWidth = RecipeCell.cellOfSize().width
        let targetHeight = RecipeCell.cellOfSize().height
        let centerX = pressPoint.x - (targetWidth / 2)
        let centerY = pressPoint.y - (targetHeight / 2)
        
        //長押し対象のセルに配置されていたものを格納するための変数
        var targetImage: UIImage? = nil
        var targetCell: RecipeCell? = nil
        
        //CollectionView内の要素で該当のセルのものを抽出する
        for targetView in receiptCollectionView.subviews {
            if targetView is RecipeCell {
                let cc: RecipeCell = targetView as! RecipeCell
                if cc.tag == targetTag {

                    //該当のセルとその中に配置されているUIImageを抽出する
                    targetCell = cc
                    targetImage = targetCell?.recipeImageView.image
                    break
                }
            }
        }
        
        //UILongPressGestureRecognizerが開始された際の処理
        if sender.state == UIGestureRecognizerState.began {
            
            //ドラッグ可能なImageViewを作成する
            draggableImageView = UIImageView()
            draggableImageView.contentMode = .scaleAspectFill
            draggableImageView.clipsToBounds = true
            draggableImageView.frame = CGRect(
                x: centerX,
                y: centerY,
                width: targetWidth,
                height:targetHeight
            )
            
            //対象のサムネイル画像を取得する処理に置き換える
            draggableImageView.image = targetImage
            self.view.addSubview(draggableImageView)

            //セル内のサムネイル画像を表示させないようにする
            targetCell?.recipeImageView.isHidden = true
        }

        //UILongPressGestureRecognizerが動作中の際の処理
        if sender.state == UIGestureRecognizerState.changed {

            //動いた分の距離を加算する
            draggableImageView.frame = CGRect(
                x: centerX,
                y: centerY,
                width: targetWidth,
                height:targetHeight
            )
            
            //ドラッグ可能なImageViewとぶつかる範囲の設定
            let minX = dragAreaButton.frame.origin.x - targetWidth
            let maxX = dragAreaButton.frame.origin.x + dragAreaButton.frame.size.width
            let minY = dragAreaButton.frame.origin.y - targetHeight
            let maxY = dragAreaButton.frame.origin.y + dragAreaButton.frame.size.height

            //DEBUG: ぶつかるエリアの具体的な値
            //print("x:\(minX) ~ \(maxX), y:\(minY) ~ \(maxY)");
            //print("x:\(pressPoint.x), y:\(pressPoint.y)");

            if ((minX <= centerX && centerX <= maxX) && (minY <= centerY && centerY <= maxY)) {

                //ぶつかる範囲内にドラッグ可能なImageViewがある場合
                dragAreaButton.backgroundColor = UIColor.orange
                isSelectedFlag = true

            } else {

                //ぶつかる範囲内にドラッグ可能なImageViewがない場合
                dragAreaButton.backgroundColor = UIColor.lightGray
                isSelectedFlag = false
            }
        }

        //UILongPressGestureRecognizerが終了した際の処理
        if sender.state == UIGestureRecognizerState.ended {
            
            //ドラッグ可能なImageViewを削除する
            targetImage = nil
            draggableImageView.image = nil
            draggableImageView.removeFromSuperview()

            //対象のcellにあるImageViewを表示
            targetCell?.recipeImageView.isHidden = false

            //ぶつかる範囲の基準となるボタンの色を戻す
            dragAreaButton.backgroundColor = UIColor.lightGray
            
            if isSelectedFlag {

                //登録できる最大数以下の場合は選択時の処理を行う
                if selectedDataList.count < RecipeSetting.recipeMaxCount {

                    //選択済みデータに追加する処理を作成する
                    selectedDataList.append(selectedData)

                    //CollectionView内のデータを1件削除して更新する処理を作成する
                    apiDataList.remove(at: targetTag)
                    receiptCollectionView.reloadData()

                    //レシピの現在選択数を表示する
                    selectedRecipeCountLabel.text = MessageSetting.getCountRecipeMessage(count: selectedDataList.count)
                }
            }

            //選択状態フラグをリセットする
            isSelectedFlag = false
        }

    }

    /* (UICollectionViewDataSource) */
    
    //セクションのアイテム数を設定する
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apiDataList.count
    }
    
    //セルに表示する値を設定する
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //セルの定義を行う
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell

        //セルへ受け渡された値を設定する
        let targetData = apiDataList[indexPath.row]
        cell.recipeNameLabel.text = targetData.title
        cell.recipeDateLabel.text = targetData.published
        cell.recipeCategoryLabel.text = targetData.indication
        
        //Kingfisherのキャッシュを活用した画像データの設定
        let url = URL(string: targetData.image)
        cell.recipeImageView.kf.indicatorType = .activity
        cell.recipeImageView.kf.setImage(with: url)

        //cellのタグを決定する(LongTapGestureRecognizerからの逆引き用に設定)
        cell.tag = indexPath.row
        
        //LongTapGestureRecognizerの定義を行う
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MakeReciptController.longPressCell(sender:)))
        
        //イベント発生までのタップ時間：0.24秒
        longPressGesture.minimumPressDuration = 0.24

        //指のズレを許容する範囲：10px
        longPressGesture.allowableMovement = 10.0

        //セルに対してLongTapGestureRecognizerを付与する
        cell.addGestureRecognizer(longPressGesture)

        return cell
    }
    
    /* (UICollectionViewDelegateFlowLayout) */

    //セル名「RecipeCell」のサイズを返す
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //セルのサイズを返す（配置したUICollectionViewのセルの高さを合わせておく必要がある）
        return RecipeCell.cellOfSize()
    }
    
    //セルの垂直方向の余白(margin)を設定する
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    //セルの水平方向の余白(margin)を設定する
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    //セル内のアイテム間の余白(margin)調整を行う
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /* (Fileprivate functions) */

    //Alamofireでの楽天レシピAPIからランキング上位のレシピ情報をカテゴリー
    fileprivate func loadApiData(categoryId: String) {

        //通信中はCollectionViewの操作をロックする
        receiptCollectionView.isUserInteractionEnabled = false
        receiptCollectionView.alpha = 0.35

        //楽天APIへのアクセスを行う
        let parameterList = ["format" : "json", "applicationId" : CommonSetting.apiKey, "categoryId" : categoryId]
        let api = ApiManager(path: "/Recipe/CategoryRanking/20121121", method: .get, parameters: parameterList)
        api.request(success: { (data: Dictionary) in
            
            //取得結果のデータにSwiftyJSONを適用する
            let jsonList = JSON(data)
            let results = jsonList["result"]

            //取得した結果を表示用の配列に格納する
            for (_, result) in results {
                
                //レシピの公開日をyyyy:MM:ddの形式にする
                let recipePublishday = String(describing: result["recipePublishday"])
                let published = recipePublishday.substring(to: recipePublishday.index(recipePublishday.startIndex, offsetBy: 10))
                
                //CollectionViewへ表示するためのデータをまとめたタプル
                let targetData = (
                    String(describing: result["recipeId"]),
                    String(describing: result["recipeIndication"]),
                    published,
                    String(describing: result["recipeTitle"]),
                    String(describing: result["foodImageUrl"]),
                    String(describing: result["recipeUrl"])
                    ) as (id: String, indication: String, published: String, title: String, image: String, url: String)

                //表示用のデータを追加する
                self.apiDataList.append(targetData)
            }

            //CollectionViewをリロードする
            self.receiptCollectionView.isUserInteractionEnabled = true
            self.receiptCollectionView.alpha = 1
            self.receiptCollectionView.reloadData()

        }, fail: { (error: Error?) in
            
            //エラーハンドリングを行う（AlertControllerを表示）
            let errorAlert = UIAlertController(
                title: "通信状態エラー",
                message: "データの取得に失敗しました。通信状態の良い場所ないしはお持ちのWiftに接続した状態で再度更新ボタンを押してお試し下さい。",
                preferredStyle: UIAlertControllerStyle.alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default,
                    handler: nil
                )
            )
            self.receiptCollectionView.isUserInteractionEnabled = true
            self.receiptCollectionView.alpha = 1
            self.present(errorAlert, animated: true, completion: nil)
        })
    }
    
    //UI表示の初期化を行う
    fileprivate func initDefaultUiSetting() {

        //UIパーツの表示時の設定をここに記載する
        dragAreaButton.addTarget(self, action: #selector(MakeReciptController.handleButtonTapped(button:)), for: .touchUpInside)

        //ボタンに関するターゲットの設定を行う
        reloadDataButton.addTarget(self, action: #selector(MakeReciptController.reloadButtonTapped(button:)), for: .touchUpInside)
        reloadDataButton.layer.cornerRadius = CGFloat(reloadDataButton.frame.width / 2)
        
        resetDataButton.addTarget(self, action: #selector(MakeReciptController.resetButtonTapped(button:)), for: .touchUpInside)
        resetDataButton.layer.cornerRadius = CGFloat(resetDataButton.frame.width / 2)
    }
    
    //メッセージ表示の初期化を行う
    fileprivate func initTargetMessageSetting() {

        //データ一時格納用の変数を初期化する
        selectedDataList.removeAll()
        apiDataList.removeAll()

        //選択リセット時または初期表示時のメッセージを表示する
        currentYearAndMonthLabel.text = MessageSetting.getDisplayYearAndMonth()
        selectedDayLabel.text = MessageSetting.getClearDateMessage()
        selectedRecipeCountLabel.text = MessageSetting.getClearRecipeMessage()

        //collectionViewのリロードを行う
        receiptCollectionView.reloadData()
    }

    //コンテンツ用のUIScrollViewの初期化を行う
    fileprivate func initScrollViewDefinition() {
        
        //スクロールビュー内の各プロパティ値を設定する
        calendarScrollView.isPagingEnabled = false
        calendarScrollView.isScrollEnabled = true
        calendarScrollView.isDirectionalLockEnabled = false
        calendarScrollView.showsHorizontalScrollIndicator = false
        calendarScrollView.showsVerticalScrollIndicator = false
        calendarScrollView.bounces = false
        calendarScrollView.scrollsToTop = false
    }

}
