//
//  AddController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/31.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import SafariServices

class AddController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SFSafariViewControllerDelegate {

    //ポップアップ用のUIパーツの配置
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!

    //データ格納用の配列
    var targetSelectedDataList: [(id: String, indication: String, published: String, title: String, image: String, url: String)] = []

    //選択された日を設定する
    var targetDate: String = "" {
        didSet {
            self.dateTextField.text = targetDate
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //tableViewのデリゲート/データソースの定義
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        recipeTableView.rowHeight = 50.5

        //textFieldのデリゲート
        memoTextField.delegate = self

        
        //UI設定及び値のセットを行う
        initDefaultUiSetting()
        setTargetDataForSave()
        
        //初回呼び出し時にはコンテンツ全体を非表示状態にしておく
        self.view.alpha = 0.0

        //Xibのクラスを読み込む宣言を行う
        let nibTableView: UINib = UINib(nibName: "TargetRecipeCell", bundle: nil)
        recipeTableView.register(nibTableView, forCellReuseIdentifier: "TargetRecipeCell")
    }

    /* (UITableViewDelegate) */

    //テーブルのセクションのセル数を設定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetSelectedDataList.count
    }

    /* (UITableViewDataSource) */

    //Editableの状態にする
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //Buttonを拡張＆データ削除処理
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //レシピを見るボタン
        let myViewButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "View") { (action, index) -> Void in

            //テーブルビューを編集不可にする
            tableView.isEditing = false

            //SafariViewControllerでレシピを閲覧できるようにする
            let targetData = self.targetSelectedDataList[indexPath.row]
            let link_url = URL(string: targetData.url)
            let safariViewController = SFSafariViewController(url: link_url!)
            safariViewController.delegate = self
            self.present(safariViewController, animated: true, completion: nil)
        }
        myViewButton.backgroundColor = UIColor.orange

        //削除ボタン
        let myDeleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            
            //テーブルビューを編集不可にする
            tableView.isEditing = false
            
            //データを1件削除(※ targetSelectedDataListから値が0になった場合は元の画面に戻す)
            self.targetSelectedDataList.remove(at: indexPath.row)
            if self.targetSelectedDataList.count > 0 {
                self.recipeTableView.reloadData()
            } else {
                self.removeAnimatePopup()
            }
        }
        myDeleteButton.backgroundColor = UIColor.red

        return [myViewButton, myDeleteButton]
    }

    //TableView: 表示するセルの中身を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Xibファイルを元にデータを作成する
        let cell = tableView.dequeueReusableCell(withIdentifier: "TargetRecipeCell") as? TargetRecipeCell
        let targetData = targetSelectedDataList[indexPath.row]
        
        //セルへ受け渡された値を設定する
        cell?.recipeName.text = targetData.title
        
        //Kingfisherのキャッシュを活用した画像データの設定
        let url = URL(string: targetData.image)
        cell?.recipeMiniImage.image = nil
        cell?.recipeMiniImage.kf.indicatorType = .activity
        cell?.recipeMiniImage.kf.setImage(with: url)

        //セルのアクセサリタイプと背景の設定
        cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }

    //Viewの表示が完了した際に呼び出されるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //ポップアップ表示を実行する
        showAnimatePopup()
    }

    //ポップアップを閉じる時のアクション
    @IBAction func closePopupAction(_ sender: UIButton) {

        //ポップアップ削除を実行する
        removeAnimatePopup()
    }

    //レシピを登録する時のアクション
    @IBAction func saveRecipeAction(_ sender: UIButton) {

        closeButton.isEnabled = false
        saveButton.isEnabled = false

        //TODO: Realmにデータを保存する処理
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* (fileprivate functions) */

    //UI表示の初期化を行う
    fileprivate func initDefaultUiSetting() {
        
        //UIパーツの表示時の設定をここに記載する
        closeButton.isEnabled = true
        closeButton.layer.cornerRadius = CGFloat(closeButton.frame.width / 2)
        closeButton.layer.borderWidth = 2.0
        closeButton.layer.borderColor = UIColor.white.cgColor
        
        saveButton.isEnabled = true
        dateTextField.isEnabled = false
    }

    //値のセットをを行う
    fileprivate func setTargetDataForSave() {
        
        //tableViewのリロードを行う
        recipeTableView.reloadData()
    }

    //ポップアップアニメーションを実行する（実行するまではアルファが0でこのUIViewControllerが拡大している状態）
    fileprivate func showAnimatePopup() {
        self.view.transform = CGAffineTransform(scaleX: 1.38, y: 1.38)
        UIView.animate(withDuration: 0.16, animations: {
            
            //おおもとのViewのアルファ値を1.0にして拡大比率を元に戻す
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    //ポップアップアニメーションを閉じる（実行するまではアルファが1でこのUIViewControllerが等倍の状態）
    fileprivate func removeAnimatePopup() {
        UIView.animate(withDuration: 0.16, animations: {
            
            //おおもとのViewのアルファ値を0.0にして拡大比率を拡大した状態に変更
            self.view.transform = CGAffineTransform(scaleX: 1.38, y: 1.38)
            self.view.alpha = 0.0
            
        }, completion:{ finished in
            
            //アニメーションが完了した際に遷移元に戻す（このクラスで独自アニメーションを定義しているので第1引数:animatedをfalseにしておく）
            self.dismiss(animated: false, completion: nil)
        })
    }

}
