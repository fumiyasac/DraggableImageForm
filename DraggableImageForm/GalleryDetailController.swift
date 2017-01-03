//
//  GalleryDetailController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2017/01/03.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryDetailController: UIViewController, UIViewControllerTransitioningDelegate {

    //背景のimageView
    @IBOutlet weak var backgroundImageView: UIImageView!

    //遷移元のViewControllerから引き渡されたレシピデータ
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //レシピデータから画像をセットする
        let url = URL(string: (recipe?.rakuten_image)!)
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: url)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

        //このView全体にタグ名とTapGestureを付与する
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GalleryDetailController.backThumbnail(sender:)))
        view.addGestureRecognizer(tapGesture)
    }

    //前の画面に戻るアクションをTapGestureをトリガーにして実行する
    func backThumbnail(sender: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
