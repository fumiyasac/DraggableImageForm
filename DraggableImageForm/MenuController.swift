//
//  MenuController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2017/01/03.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

//メニューボタンを閉じる処理を実装するためのプロトコル
protocol MenuCloseDelegate {
    func closeMenuStatus(status: MenuStatus)
}

class MenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //UIパーツの配置
    @IBOutlet weak var menuCollectionView: UICollectionView!

    //メニュー部分開閉用のプロトコルのための変数
    var delegate: MenuCloseDelegate!

    //メニュー用のデータ
    var menuData: [[String]] = [] {
        didSet {
            self.menuCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //コレクションビューのデリゲート・データソース
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self

        //メニュー用のデータをセットする
        menuData = MenuMaker.setMenuList()

        //画像のセルを定義する
        let nibCell: UINib = UINib(nibName: "MenuThumbCell", bundle: nil)
        menuCollectionView.register(nibCell, forCellWithReuseIdentifier: "MenuThumbCell")
    }

    /* (UICollectionViewDelegate) */
    
    //このコレクションビューのセクション数を決める
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /* (UICollectionViewDataSource) */
    
    //このコレクションビューのセル数を決める
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuData.count
    }
    
    //このコレクションビューのセル内へ写真の配置を行う
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuThumbCell", for: indexPath) as? MenuThumbCell

        //メニューのデータを設定する
        let targetMenu = menuData[indexPath.row]
        cell?.thumbImageView.image = UIImage(named: targetMenu[0])
        cell?.thumbMenuName.text = targetMenu[1]
        
        return cell!
    }
    
    //このコレクションビューのセルをタップした際の写真を選択する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //TODO: 選択した際のアクションを決定する
        //let selectedCell = collectionView.cellForItem(at: indexPath) as? MenuThumbCell
    }
    
    /* (Button Actions) */
    @IBAction func closeMenuAction(_ sender: UIButton) {

        //デリゲートメソッドの実行（処理の内容はViewControllerに記載する）
        self.delegate.closeMenuStatus(status: MenuStatus.closed)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
