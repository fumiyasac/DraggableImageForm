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

    //セルを表示しようとする時の動作を設定する
    /**
     * willDisplay(UITableViewDelegateのメソッド)に関して
     *
     * 参考: Cocoa API解説(macOS/iOS) tableView:willDisplayCell:forRowAtIndexPath:
     * https://goo.gl/Ykp30Q
     */
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /**
         * CoreAnimationを利用したアニメーションをセルの表示時に付与する（拡大とアルファの重ねがけ）
         *
         * 参考:【iOS Swift入門 #185】Core Animationでアニメーションの加速・減速をする
         * http://swift-studying.com/blog/swift/?p=1162
         */
        
        /* ----- 2017/01/04:処理が表示にそぐわない気もしたのでコメントアウト -----
        //アニメーションの作成
        let groupAnimation = CAAnimationGroup()
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.duration = 0.28
        groupAnimation.beginTime = CACurrentMediaTime() + 0.16
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        //拡大するアニメーション
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.64
        scaleAnimation.toValue = 1.0
        
        //透過を変更するアニメーション
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        
        //作成した個別のアニメーションをグループ化
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        
        //セルのLayerにアニメーションを追加
        cell.layer.add(groupAnimation, forKey: nil)
        
        //アニメーション終了後は元のサイズになるようにする
        cell.layer.transform = CATransform3DIdentity
        */
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

                //遷移元からポップアップ用のGalleryControllerのインスタンスを作成する
                let galleryVC = UIStoryboard(name: "Gallery", bundle: nil).instantiateViewController(withIdentifier: "GalleryController") as! GalleryController
                
                //ポップアップ用のViewConrollerを設定し、modalPresentationStyle(= .overCurrentContext)と背景色(= UIColor.clear)を設定する
                galleryVC.modalPresentationStyle = .overCurrentContext
                galleryVC.view.backgroundColor = UIColor.clear
                
                //変数の受け渡しを行う
                galleryVC.recipeData = recipes
                
                //ポップアップ用のViewControllerへ遷移
                self.present(galleryVC, animated: false, completion: nil)
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
