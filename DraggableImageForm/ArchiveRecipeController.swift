//
//  ArchiveRecipeController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/06.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ArchiveRecipeController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    //Realmから取得したデータをセットする
    var archiveList: [Archive] = [] {
        didSet {
            self.archiveRecipeTableView.reloadData()
        }
    }
    
    //アーカイブ表示用のtableView
    @IBOutlet weak var archiveRecipeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //テーブルビューのセットアップ
        archiveRecipeTableView.delegate = self
        archiveRecipeTableView.dataSource = self
        archiveRecipeTableView.rowHeight = 199
        
        //Xibのセットアップ
        let nibTableView: UINib = UINib(nibName: "ArchiveCell", bundle: nil)
        archiveRecipeTableView.register(nibTableView, forCellReuseIdentifier: "ArchiveCell")
    }

    /* (UITableViewDelegate) */
    
    //テーブルのセクションのセル数を設定する
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        //return archiveList.count
    }
    
    /* (UITableViewDataSource) */
    
    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveCell") as? ArchiveCell
        
        //仮のデータを設計してセルに表示させる
        /*
        cell?.restaurantName.text = "Mexican Dinning"
        cell?.restaurantThumbnail.image = UIImage(named: "sample")
        cell?.restaurantOpen.text = "11:30 ~ 23:00"
        cell?.restaurantLunchTime.text = "Lunch 11:30 ~ 14:00"
        cell?.restaurantDetail.text = "このお店はタコスが絶品です。本場のタコスとテキーラで仕事帰りやランチタイムで最高の気分を味わって見ましょう！"
        */
        
        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
