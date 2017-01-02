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
            let archiveData = archiveList[indexPath.row]
            let recipes: [Recipe] = Recipe.fetchAllRecipeListByArchiveId(archive_id: archiveData.id)

            //1枚目の画像を見せておくようにする
            let url = URL(string: (recipes.first?.rakuten_image)!)
            cell?.archiveImageView.kf.indicatorType = .activity
            cell?.archiveImageView.kf.setImage(with: url)

            //レシピギャラリー一覧ページを表示する
            cell?.showGalleryClosure = {
                print("showGalleryClosure! indexPath:\(indexPath.row)")
            }

            //データ表示用のUIAlertControllerを表示する
            cell?.deleteArchiveClosure = {

                //データ削除の確認用ポップアップを表示する
                let deleteAlert = UIAlertController(
                    title: "データ削除",
                    message: "このデータを削除しますか？(削除をする場合にはこのデータに紐づくレシピデータも一緒に削除されます。)",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                deleteAlert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: UIAlertActionStyle.default,
                        handler: { (action: UIAlertAction!) in
                            
                            //Realmから該当データを1件削除する処理
                            for recipe in recipes {
                                recipe.delete()
                            }
                            archiveData.delete()
                            
                            //登録されているデータの再セットを行う
                            self.archiveList = Archive.fetchAllCalorieListSortByDate()
                    })
                )
                deleteAlert.addAction(
                    UIAlertAction(
                        title: "キャンセル",
                        style: UIAlertActionStyle.cancel,
                        handler: nil
                    )
                )                
                self.present(deleteAlert, animated: true, completion: nil)
            }
            
            //アーカイブデータを取得する
            cell?.archiveDate.text = DateConverter.convertDateToString(archiveData.created)
            cell?.archiveMemo.text = archiveData.memo
        }

        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
