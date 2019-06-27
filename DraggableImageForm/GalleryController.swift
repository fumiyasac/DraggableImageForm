//
//  GalleryController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/07.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {

    //タップ時に選択したimageViewを格納するための変数
    var selectedImage: UIImageView?

    //表示対象の画像URL一覧(サムネイルURL一覧)
    var recipeData: [Recipe] = [] {
        didSet {

            //アーカイブしたレシピ数を表示する
            self.totalCount.text = "合計: \(recipeData.count)件登録中"
        }
    }

    //サムネイル表示用のscrollView
    @IBOutlet weak var thumbnailScrollView: UIScrollView!

    //登録レシピ数を表示するラベル
    @IBOutlet weak var totalCount: UILabel!
    
    //カスタムトランジション用クラスのインスタンス
    let transition = CustomTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スクロールビューのデリゲート
        thumbnailScrollView.delegate = self

        //初回呼び出し時にはコンテンツ全体を非表示状態にしておく
        self.view.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //ポップアップ表示を実行する
        showAnimatePopup()
    }
    
    //レイアウト処理が完了した際のライフサイクル
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //コンテンツ用のScrollViewを初期化
        initScrollViewDefinition()

        //画像サムネイルのサイズの設定
        let imageWidth  = Int(180.0 * (DeviceSize.screenWidth() / DeviceSize.screenHeight()))
        let imageHeight = 180
        let imageSpace  = 10
        
        //スクロールビュー内のサイズを決定する
        thumbnailScrollView.contentSize = CGSize(
            width: imageWidth * recipeData.count + imageSpace * (recipeData.count - 1),
            height: imageHeight
        )

        //カレンダーのスクロールビュー内にボタンを配置する
        for i in 0...(recipeData.count - 1) {

            //サムネイルを作成する
            let thumbnailImageView = UIImageView()
            let url = URL(string: (recipeData[i].rakuten_image))
            thumbnailImageView.kf.indicatorType = .activity
            thumbnailImageView.kf.setImage(with: url)
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.clipsToBounds = true

            //メニュー用のスクロールビューにサムネイルを配置
            thumbnailScrollView.addSubview(thumbnailImageView)

            //サムネイルのサイズ・中心位置を設定する
            thumbnailImageView.frame = CGRect(
                x: (imageWidth + imageSpace) * i,
                y: 0,
                width: imageWidth,
                height: imageHeight
            )

            //サムネイルにタグ名とTapGestureを付与する
            thumbnailImageView.tag = i
            thumbnailImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GalleryController.expandThumbnail(sender:)))
            thumbnailImageView.addGestureRecognizer(tapGesture)
        }
    }

    //サムネイルを拡大表示するためのアクション
    @objc func expandThumbnail(sender: UITapGestureRecognizer) {

        //遷移対象をサムネイル画像とデータを設定する
        selectedImage = sender.view as? UIImageView
        let tagNumber = sender.view?.tag
        let selectedRecipeData = recipeData[tagNumber!]

        //カスタムトランジションを適用した画面遷移を行う
        let garellyDetail = storyboard!.instantiateViewController(withIdentifier: "GalleryDetailController") as! GalleryDetailController
        garellyDetail.recipe = selectedRecipeData
        garellyDetail.transitioningDelegate = self
        self.present(garellyDetail, animated: true, completion: nil)
    }
    
    /* (UIViewControllerTransitioningDelegate) */

    /**
     * カスタムトランジションは下記のサンプルをSwift3に置き換えて再実装
     * (実装の詳細はCustomTransition.swiftを参考)
     * 
     * 参考：iOS Animation Tutorial: Custom View Controller Presentation Transitions
     * https://www.raywenderlich.com/113845/ios-animation-tutorial-custom-view-controller-presentation-transitions
     */

    //進む場合のアニメーションの設定を行う
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        //選択したサムネイル画像の位置とサイズの情報を引き渡す
        transition.originalFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    //戻る場合のアニメーションの設定を行う
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transition.presenting = false
        return transition
    }

    /* (Button Actions) */
    
    //ポップアップを閉じるアクション
    @IBAction func closeGalleryAction(_ sender: UIButton) {
        
        //ポップアップ削除を実行する
        removeAnimatePopup()
    }

    /* (Fileprivate functions) */
    
    //コンテンツ用のUIScrollViewの初期化を行う
    fileprivate func initScrollViewDefinition() {
        
        //スクロールビュー内の各プロパティ値を設定する
        thumbnailScrollView.isPagingEnabled = false
        thumbnailScrollView.isScrollEnabled = true
        thumbnailScrollView.isDirectionalLockEnabled = false
        thumbnailScrollView.showsHorizontalScrollIndicator = false
        thumbnailScrollView.showsVerticalScrollIndicator = false
        thumbnailScrollView.bounces = true
        thumbnailScrollView.scrollsToTop = false
    }
    
    //ポップアップアニメーションを実行する（実行するまではアルファが0でこのUIViewControllerが拡大している状態）
    fileprivate func showAnimatePopup() {

        UIView.animate(withDuration: 0.16, animations: {
            
            //おおもとのViewのアルファ値を1.0に戻す
            self.view.alpha = 1.0
        })
    }
    
    //ポップアップアニメーションを閉じる（実行するまではアルファが1でこのUIViewControllerが等倍の状態）
    fileprivate func removeAnimatePopup() {

        UIView.animate(withDuration: 0.16, animations: {
            
            //おおもとのViewのアルファ値を0.0に変更する
            self.view.alpha = 0.0
            
        }, completion:{ finished in
            
            //アニメーションが完了した際に遷移元に戻す（このクラスで独自アニメーションを定義しているので第1引数:animatedをfalseにしておく）
            self.dismiss(animated: false, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
