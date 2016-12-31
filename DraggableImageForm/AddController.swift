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

    //初回キーボード表示用のメンバ変数
    var lastKeyboardFrame: CGRect = CGRect.zero

    //データ格納用の配列
    var targetSelectedDataList: [(id: String, indication: String, published: String, title: String, image: String, url: String)] = []

    //選択された日を設定する
    var targetDate: String = "" {
        
        //値がセットされたタイミングで日付をセット
        didSet {
            self.dateTextField.text = targetDate
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //通知（キーボード）に関する処理を登録する
        registerNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //ポップアップ表示を実行する
        showAnimatePopup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //通知（キーボード）に関する処理を解除する
        unregisterNotification()
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
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetSelectedDataList.count
    }

    /* (UITableViewDataSource) */

    //Editableの状態にする
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    //Buttonを拡張＆データ削除処理
    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //レシピを見るボタン
        let myViewButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "閲覧") { (action, index) -> Void in

            //テーブルビューを編集不可にする
            tableView.isEditing = false

            //SafariViewControllerでレシピを閲覧できるようにする
            let targetData = self.targetSelectedDataList[indexPath.row]
            let link_url = URL(string: targetData.url)
            let safariViewController = SFSafariViewController(url: link_url!)
            safariViewController.delegate = self
            self.present(safariViewController, animated: true, completion: nil)
        }
        myViewButton.backgroundColor = ColorConverter.colorWithHexString(hex: WebColorLists.lightOrangeCode.rawValue)

        //削除ボタン
        let myDeleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
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
        myDeleteButton.backgroundColor = ColorConverter.colorWithHexString(hex: WebColorLists.lightBrownCode.rawValue)

        return [myViewButton, myDeleteButton]
    }

    //表示するセルの中身を設定する
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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

    /* (UITextFieldDelegate) */

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /* (Observer Functions) */

    //通知登録処理
    func registerNotification() {

        //キーボードの開閉時の通知登録を行う
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(AddController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(AddController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    //通知登録解除処理
    func unregisterNotification() {

        //キーボードの開閉時の通知登録を解除する
        let center: NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //Keyboard表示前処理
    func keyboardWillShow(notification: Notification) {
        movePopupPosition(notification: notification, showKeyboard: true)
    }
    
    //Keyboard非表示前処理
    func keyboardWillHide(notification: Notification) {
        movePopupPosition(notification: notification, showKeyboard: false)
    }
    
    //ポップアップを閉じる時のアクション
    @IBAction func closePopupAction(_ sender: UIButton) {

        //ポップアップ削除を実行する
        removeAnimatePopup()
    }

    //レシピを登録する時のアクション
    @IBAction func saveRecipeAction(_ sender: UIButton) {

        //キーボードを閉じる
        view.endEditing(true)

        //ボタンを非活性状態にする
        closeButton.isEnabled = false
        saveButton.isEnabled = false

        //Realmにデータを保存する処理(もうちょっと綺麗にリファクタする)
        let archiveObject = Archive.create()
        let archive_id = Archive.getLastId()
        archiveObject.memo = memoTextField.text!
        archiveObject.created = DateConverter.convertStringToDate(dateTextField.text)
        archiveObject.save()

        for targetData in targetSelectedDataList {
            let recipeObject = Recipe.create()
            recipeObject.archive_id = archive_id
            recipeObject.rakuten_id = targetData.id
            recipeObject.rakuten_indication = targetData.indication
            recipeObject.rakuten_published = targetData.published
            recipeObject.rakuten_title = targetData.title
            recipeObject.rakuten_image = targetData.image
            recipeObject.rakuten_url = targetData.url
            recipeObject.save()
        }
        removeAnimatePopup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* (fileprivate functions) */

    //UI表示の初期化を行う
    fileprivate func initDefaultUiSetting() {
        
        //UIパーツの表示時の設定をここに記載する
        popupView.center = CGPoint(
            x: DeviceSize.screenWidth() / 2,
            y: DeviceSize.screenHeight() / 2
        )
        
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

    //テーブルビューの位置補正を行う
    fileprivate func movePopupPosition(notification: Notification, showKeyboard: Bool) -> () {
        
        if showKeyboard {
            
            //keyboardのサイズを取得
            var keyboardFrame: CGRect = CGRect.zero
            if let userInfo = notification.userInfo {
                if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                    keyboardFrame = keyboard.cgRectValue
                }
            }

            //前の表示時のキーボード高さが0(初めてキーボードを表示した)の場合にはポップアップ位置をずらす
            //※ キーボードが表示されている状態で次の入力項目に移った場合はこの処理を行わない
            if lastKeyboardFrame.height == 0 {

                lastKeyboardFrame = keyboardFrame
                UIView.animate(withDuration: 0.26, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations:{

                    //キーボードの分だけ上にずらす
                    self.popupView.center = CGPoint(x: DeviceSize.screenWidth() / 2, y: DeviceSize.screenHeight() / 2 - keyboardFrame.height)

                }, completion: nil)
            }
            
        } else {
            
            //キーボードが隠れたらUITableViewの制約を元に戻す
            UIView.animate(withDuration: 0.26, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations:{

                //キーボードの分を元に戻す
                self.popupView.center = CGPoint(x: DeviceSize.screenWidth() / 2, y: DeviceSize.screenHeight() / 2)

            }, completion: { finished in
                self.lastKeyboardFrame = CGRect.zero
            })
        }
    }
}
