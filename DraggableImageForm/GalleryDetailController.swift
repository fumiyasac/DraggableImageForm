//
//  GalleryDetailController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2017/01/03.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class GalleryDetailController: UIViewController, UIViewControllerTransitioningDelegate, SFSafariViewControllerDelegate {

    //背景のimageView
    @IBOutlet weak var backgroundImageView: UIImageView!

    //遷移元のViewControllerから引き渡されたレシピデータ
    var recipe: Recipe!

    //UIパーツの配置
    @IBOutlet weak var targetRecipeTitle: UILabel!
    @IBOutlet weak var targetRecipeIndication: UILabel!
    @IBOutlet weak var targetRecipePublished: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        //レシピデータから画像をセットする
        let url = URL(string: (recipe?.rakuten_image)!)
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: url)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.isUserInteractionEnabled = true
        
        //背景のimageViewにタグ名とTapGestureを付与する
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GalleryDetailController.backThumbnail(sender:)))
        backgroundImageView.addGestureRecognizer(tapGesture)
        
        //レシピ情報を表示する
        targetRecipeTitle.text = recipe?.rakuten_title
        targetRecipeIndication.text = recipe?.rakuten_indication
        targetRecipePublished.text = recipe?.rakuten_published
    }

    //前の画面に戻るアクションをTapGestureをトリガーにして実行する
    @objc func backThumbnail(sender: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    /* (Button Actions) */
    
    //楽天レシピページを表示する
    @IBAction func displayRakutenRecipePageAction(_ sender: UIButton) {

        let link_url = URL(string: (recipe?.rakuten_url)!)
        let safariViewController = SFSafariViewController(url: link_url!)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
