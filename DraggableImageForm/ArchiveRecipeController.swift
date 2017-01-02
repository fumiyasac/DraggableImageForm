//
//  ArchiveRecipeController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/06.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Kingfisher

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

        //アーカイブしたレシピデータを取得する
        archiveList = Archive.fetchAllCalorieListSortByDate()
    }

    /* (UITableViewDelegate) */
    
    //テーブルのセクションのセル数を設定する
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveList.count
    }
    
    /* (UITableViewDataSource) */
    
    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveCell") as? ArchiveCell

        //アーカイブデータが空でなければセルにレシピデータを表示する
        if !archiveList.isEmpty {

            //該当のArchiveデータとそれに紐づくRecipeデータを取得
            let targetData = archiveList[indexPath.row]
            let recipes: [Recipe] = Recipe.fetchAllRecipeListByArchiveId(archive_id: targetData.id)
            
            var recipeImageUrlList: [String] = []
            for (_, recipe) in recipes.enumerated() {
                recipeImageUrlList.append(recipe.rakuten_image)
            }
            
            //1枚目の画像を見せておくようにする
            let url = URL(string: recipeImageUrlList.first!)
            cell?.archiveImageView.kf.indicatorType = .activity
            cell?.archiveImageView.kf.setImage(with: url)
            
            //TODO: クロージャーの処理の中身を記載する

            //アーカイブデータを取得する
            cell?.archiveDate.text = DateConverter.convertDateToString(targetData.created)
            cell?.archiveMemo.text = targetData.memo
        }

        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
