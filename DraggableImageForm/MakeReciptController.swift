//
//  MakeReciptController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/06.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

struct RecipeSetting {
    static let recipeMaxCount = 20
}

class MakeReciptController: UIViewController, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //ドラッグ可能なイメージビュー
    var draggableImageView: UIImageView!
    
    //選択状態
    var isSelectedFlag: Bool = false
    
    //データ格納用の配列
    //var selectedDataList: Array<Any>!
    
    //APIから取得したデータを格納する配列
    //var apiDataList: Array<Any>!
    
    //MakeReciptControllerクラス内のUIパーツ
    @IBOutlet weak var calendarScrollView: UIScrollView!
    @IBOutlet weak var receiptCollectionView: UICollectionView!
    @IBOutlet weak var dragAreaButton: UIButton!
    @IBOutlet weak var selectDataDisplayArea: UIView!

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
    }
    
    /* (Instance Methods) */
    
    //Reloadボタンを押した時のアクション
    func reloadButtonTapped(button: UIButton) {
        print("Reload button tapped.")
    }

    //Archiveボタンを押した時のアクション
    func archiveButtonTapped(button: UIButton) {
        print("Archive button tapped.")
    }

    //セルを長押しした際(UILongPressGestureRecognizerで実行された際)に発動する処理
    func longPressCell(sender: UILongPressGestureRecognizer)  {

        //長押ししたセルのタグ名と現在位置を設定する
        let targetTag: Int = (sender.view?.tag)!
        let pressPoint: CGPoint = sender.location(ofTouch: 0, in: self.view)
        
        //対象の画像サイズと中心位置を算出する
        let targetWidth = RecipeCell.cellOfSize().width
        let targetHeight = RecipeCell.cellOfSize().height
        let centerX = pressPoint.x - (targetWidth / 2)
        let centerY = pressPoint.y - (targetHeight / 2)
        
        //長押し対象のセルに配置されていたイメージ
        var targetImage: UIImage?
        var targetCell: RecipeCell?
        
        //CollectionView内の要素で該当のセルのものを抽出する
        for targetView in receiptCollectionView.subviews {
            if targetView is RecipeCell {
                let cc: RecipeCell = targetView as! RecipeCell
                if cc.tag == targetTag {
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
            print("x:\(minX) ~ \(maxX), y:\(minY) ~ \(maxY)");
            print("x:\(pressPoint.x), y:\(pressPoint.y)");

            if ((minX <= centerX && centerX <= maxX) && (minY <= centerY && centerY <= maxY)) {

                //ぶつかる範囲内にドラッグ可能なImageViewがある場合
                dragAreaButton.backgroundColor = UIColor.yellow
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

            //dropViewの色を戻す
            dragAreaButton.backgroundColor = UIColor.lightGray
            
            if isSelectedFlag {
                
                //TODO: 選択済みデータに追加する処理を作成する
                
                //TODO: CollectionView内のデータを1件削除して更新する処理を作成する

                //DEBUG: ぶつかるエリア内にある
                print("Yes")

            } else {

                //DEBUG: ぶつかるエリア内にない
                print("No")
            }
            isSelectedFlag = false
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* (UICollectionViewDataSource) */
    
    //セクションのアイテム数を設定する
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecipeSetting.recipeMaxCount
    }
    
    //セルに表示する値を設定する
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell

        //セルへ受け渡された値を設定する
        cell.recipeNameLabel.text = "せせらぎ豚の生姜焼き定食（ライス・スープ付き）"
        cell.recipeDateLabel.text = "2015/12/25"
        cell.recipeCategoryLabel.text = "主菜・メイン"
        
        //画像データの設定
        cell.recipeImageView.image = UIImage(named: "sample")!

        //cellのタグを決定する(LongTapGestureRecognizerからの逆引き用に設定)
        cell.tag = indexPath.row
        
        //セルに対してLongTapGestureRecognizerを付与する
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MakeReciptController.longPressCell(sender:)))
        
        //イベント発生までのタップ時間：0.24秒
        longPressGesture.minimumPressDuration = 0.24

        //指のズレを許容する範囲：10px
        longPressGesture.allowableMovement = 10.0
        
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

}
