//
//  CategoryList.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/28.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Foundation

//カテゴリーの一覧を取得する
struct CategoryList {

    //楽天レシピAPIの大カテゴリー一覧（※今回はStaticにもたせています...）
    fileprivate static let baseCategories: [String] = ["30","31","32","33","14","15","16","17","23","18","22","21","10","11","12","34","19","27","35","13","20","36","37","38","39","40","26","41","42","43","44","25","46","47","48","24","49","50","51","52","53","54","55"]
    
    //検索対象となるカテゴリーを取得する（※今回はサンプルのため重複は考慮していない）
    static func fetchTargetCategory() -> String {
        let index = Int(arc4random_uniform(UInt32(baseCategories.count)))
        return baseCategories[index]
    }
}
