//
//  MakeReciptController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/06.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class MakeReciptController: UIViewController {

    //ドラッグ可能なイメージビュー
    var draggableImageView: UIImageView!
    
    //選択状態
    var isSelectedFlag: Bool = false
    
    //データ格納用の配列
    var selectedDataList: Array<Any>!
    
    //APIから取得したデータを格納する配列
    var apiDataList: Array<Any>!
    
    //各種パーツのOutlet接続
    @IBOutlet weak var calendarScrollView: UIScrollView!
    @IBOutlet weak var receiptCollectionView: UICollectionView!
    @IBOutlet weak var dragAreaButton: UIButton!
    @IBOutlet weak var selectDataDisplayArea: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
