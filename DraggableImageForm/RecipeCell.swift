//
//  RecipeCell.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/22.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class RecipeCell: UICollectionViewCell {

    //CollectionViewCellクラス内のUIパーツ
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDateLabel: UILabel!
    @IBOutlet weak var recipeCategoryLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!

    //セルの幅と高さを返すクラスメソッド（配置したUICollectionViewのセルの高さを合わせておく必要がある）
    class func cellOfSize() -> CGSize {
        let width = UIScreen.main.bounds.width / 2
        let height = CGFloat(160)
        return CGSize(width: width, height: height)
    }
}
