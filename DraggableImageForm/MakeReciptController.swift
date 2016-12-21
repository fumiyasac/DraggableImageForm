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

class MakeReciptController: UIViewController, UINavigationControllerDelegate {

    //ドラッグ可能なイメージビュー
    var draggableImageView: UIImageView!
    
    //選択状態
    var isSelectedFlag: Bool = false
    
    //データ格納用の配列
    var selectedDataList: Array<Any>!
    
    //APIから取得したデータを格納する配列
    var apiDataList: Array<Any>!
    
    //MakeReciptControllerクラス内のUIパーツ
    @IBOutlet weak var calendarScrollView: UIScrollView!
    @IBOutlet weak var receiptCollectionView: UICollectionView!
    @IBOutlet weak var dragAreaButton: UIButton!
    @IBOutlet weak var selectDataDisplayArea: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: NavigationController関連の設定
    }
    
    /* (Instance Methods) */

    //セルを長押しした際の処理 ※UILongPressGestureRecognizerで実行された
    func longPressCell(sender: UILongPressGestureRecognizer)  {
        //TODO: UILongPressGestureRecognizer発動時に行われる処理を記載
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        //TODO: セル関連の設定
        
        return cell
    }
    
    //セルが選択された際の処理を設定する
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //TODO: セルタップ時の設定
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
