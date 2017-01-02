//
//  RecipeData.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Foundation
import RealmSwift

class Recipe: Object {
    
    //Realmクラスのインスタンス
    static let realm = try! Realm()

    //id
    dynamic fileprivate var id = 0

    //archive_id
    dynamic var archive_id = 0

    //楽天レシピid
    dynamic var rakuten_id = ""

    //楽天レシピ調理時間のめやす
    dynamic var rakuten_indication = ""

    //楽天レシピ公開日
    dynamic var rakuten_published = ""

    //楽天レシピタイトル
    dynamic var rakuten_title = ""

    //楽天レシピ画像URL
    dynamic var rakuten_image = ""

    //楽天レシピURL
    dynamic var rakuten_url = ""

    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let recipe = realm.objects(Recipe.self).last {
            return recipe.id + 1
        } else {
            return 1
        }
    }

    //新規追加用のインスタンス生成メソッド
    static func create() -> Recipe {
        let recipe = Recipe()
        recipe.id = self.getLastId()
        return recipe
    }
    
    //インスタンス保存用メソッド
    func save() {
        try! Recipe.realm.write {
            Recipe.realm.add(self)
        }
    }

    //インスタンス削除用メソッド
    func delete() {
        try! Recipe.realm.write {
            Recipe.realm.delete(self)
        }
    }

    //アーカイブIDに紐づくデータを全件取得をする
    static func fetchAllRecipeListByArchiveId(archive_id: Int) -> [Recipe] {
        let recipes = realm.objects(Recipe.self).filter("archive_id = %@", archive_id).sorted(byProperty: "id", ascending: true)
        var recipeList: [Recipe] = []
        for recipe in recipes {
            recipeList.append(recipe)
        }
        return recipeList
    }
}
