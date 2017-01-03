//
//  GalleryController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/07.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryController: UIViewController, UIScrollViewDelegate {

    //表示対象の画像URL一覧(サムネイルURL一覧)
    var recipeData: [Recipe] = []

    //サムネイル表示用のscrollView
    @IBOutlet weak var thumbnailScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //スクロールビューのデリゲート
        thumbnailScrollView.delegate = self
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
        let imageWidth  = 240
        let imageHeight = 180
        let imageSpace  = 10
        
        //スクロールビュー内のサイズを決定する
        thumbnailScrollView.contentSize = CGSize(
            width: imageWidth * recipeData.count + imageSpace * (recipeData.count - 1),
            height: imageHeight
        )

        //カレンダーのスクロールビュー内にボタンを配置する
        for i in 0...(recipeData.count - 1) {

            let thumbnailImageView = UIImageView()
            let url = URL(string: (recipeData[i].rakuten_image))
            thumbnailImageView.kf.indicatorType = .activity
            thumbnailImageView.kf.setImage(with: url)
            thumbnailImageView.contentMode = .scaleAspectFill
            thumbnailImageView.clipsToBounds = true

            //メニュー用のスクロールビューにボタンを配置
            thumbnailScrollView.addSubview(thumbnailImageView)

            //サイズ・中心位置の決定
            thumbnailImageView.frame = CGRect(
                x: (imageWidth + imageSpace) * i,
                y: 0,
                width: imageWidth,
                height: imageHeight
            )
            thumbnailImageView.tag = i
            thumbnailImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GalleryController.expandThumbnail(sender:)))
            thumbnailImageView.addGestureRecognizer(tapGesture)
        }
    }

    func expandThumbnail(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}
