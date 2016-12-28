//
//  APIManager.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/28.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Alamofire

//AlamofireでAPIを扱うための構造体
//下記の記事の構造体を元に戻り値を変更するように改修
//参考：http://qiita.com/tmf16/items/d2f13088dd089b6bb3e4

//APIKeyは除外（自分のサンプルでお使いの場合はアカウントを取得してお試しください）
private let host = "https://app.rakuten.co.jp/services/api"

struct ApiManager {

    //URLアクセス用のメンバ変数
    let url: String
    let method: HTTPMethod
    let parameters: Parameters
    
    init(path: String, method: HTTPMethod = .get, parameters: Parameters = [:]) {

        //イニシャライザの定義
        url = host + path
        self.method = method
        self.parameters = parameters
    }
    
    //該当APIのエンドポイントに向けてデータを取得する
    func request(success: @escaping (_ data: Dictionary<String, Any>)-> Void, fail: @escaping (_ error: Error?)-> Void) {

        //Alamofireによる非同期通信
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                success(response.result.value as! Dictionary)
            } else {
                fail(response.result.error)
            }
        }
    }
}
