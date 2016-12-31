//
//  DeviceSize.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/31.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

struct DeviceSize {
    
    //CGRectを取得
    static func bounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    //画面の横サイズを取得
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    //画面の縦サイズを取得
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
}
