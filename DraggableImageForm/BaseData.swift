//
//  BaseData.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Foundation
import RealmSwift

class BaseData: Object {
    
    //Realmクラスのインスタンス
    static let realm = try! Realm()
    
    //ID
    dynamic fileprivate var id = 0
    
    //メモ
    dynamic var memo = ""

    //登録日
    dynamic var baseDataDate = Date(timeIntervalSince1970: 0)

    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let baseData = realm.objects(BaseData.self).last {
            return baseData.id + 1
        } else {
            return 1
        }
    }
}
