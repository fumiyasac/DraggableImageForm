//
//  RecipeData.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Foundation
import RealmSwift

class RecipeData: Object {
    
    //Realmクラスのインスタンス
    static let realm = try! Realm()

    //ID
    dynamic fileprivate var id = 0
    
    //TODO: レシピデータの定義
    
    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let recipeData = realm.objects(RecipeData.self).last {
            return recipeData.id + 1
        } else {
            return 1
        }
    }
}
