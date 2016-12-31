//
//  BaseData.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Foundation
import RealmSwift

class Archive: Object {
    
    //Realmクラスのインスタンス
    static let realm = try! Realm()
    
    //id
    dynamic fileprivate var id = 0
    
    //メモ
    dynamic var memo = ""

    //登録日
    dynamic var created = Date(timeIntervalSince1970: 0)

    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let archive = realm.objects(Archive.self).last {
            return archive.id + 1
        } else {
            return 1
        }
    }

    //新規追加用のインスタンス生成メソッド
    static func create() -> Archive {
        let archive = Archive()
        archive.id = self.getLastId()
        return archive
    }

    //インスタンス保存用メソッド
    func save() {
        try! Archive.realm.write {
            Archive.realm.add(self)
        }
    }
    
    //登録日順のデータの全件取得をする
    static func fetchAllCalorieListSortByDate() -> [Archive] {
        let archives = realm.objects(Archive.self).sorted(byProperty: "created", ascending: false)
        var archiveList: [Archive] = []
        for archive in archives {
            archiveList.append(archive)
        }
        return archiveList
    }
}
