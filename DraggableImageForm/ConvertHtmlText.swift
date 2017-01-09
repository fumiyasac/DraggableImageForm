//
//  ConvertHtmlText.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2017/01/09.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

//HTMLタグを有効にするための構造体
struct ConvertHtmlText {
    
    //HTMLタグを有効にするメソッド
    static func activateHtmlTags(targetString: String) -> NSAttributedString {
        
        //対象のテキスト（この中にはHTMLタグや簡単な直書きのCSSがあることを想定）
        let htmlText: String = targetString
        
        /**
         * 行間を調節するにはNSAttributedString(またはNSMutableAttributedString)を使用する。
         *
         * (イメージ) CSSのline-heightのようなイメージ「line-height: 1.8;」
         * http://easyramble.com/set-line-height-with-swift.html
         *
         * (参考)【iOS Swift入門 #120】UILabelで複数行の文字列を表示するときに行間を調節する
         * http://swift-studying.com/blog/swift/?p=553
         */
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 2.0
        
        //HTMLに対応した文字列に直す処理とオプションの設定を行う
        let encodedData = htmlText.data(using: String.Encoding.utf8)!
        let attributedOptions : [String : AnyObject] = [
            NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType as AnyObject,
            NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject,
            NSParagraphStyleAttributeName : paragraph
        ]
        
        let attributedString = try! NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
        
        return attributedString
    }

    //クレジット表記用のテキストを取得する
    static func getCreditText() -> String {
        return
            "<b style=\"color:#ffffff;\">本サンプルで使用しているデータについて：</b><br><br>" +
            "<b><a href=\"http://webservice.rakuten.co.jp/\" target=\"_blank\">Supported by 楽天ウェブサービス</a></b><br><br>" +
        "<span style=\"color:#ffffff;\">このサンプル内で利用しているレシピデータに関しては「楽天ウェブサービス」様が提供している「楽天レシピカテゴリ別ランキングAPI」のデータを利用しています。<br><br>またこのサンプルに関してはAPIキーを含んでいませんので、データの取得及びパラメータの設定方法に関しては、「楽天ウェブサービス」様の公式ドキュメント及び本サンプルのAPIアクセス部分のロジックを参考にして実装を行って下さい。<br><br>（楽天ウェブサービスのアカウント取得に関しては上記のリンクより取得をしてください）</span>"
    }
}
