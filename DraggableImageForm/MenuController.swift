//
//  MenuController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2017/01/03.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

//メニューボタンを閉じる処理を実装するためのプロトコル
protocol MenuCloseDelegate {
    func closeMenuStatus(status: MenuStatus)
}

class MenuController: UIViewController {

    //メニュー部分開閉用のプロトコルのための変数
    var delegate: MenuCloseDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /* (Button Actions) */
    @IBAction func closeMenuAction(_ sender: UIButton) {

        //デリゲートメソッドの実行（処理の内容はViewControllerに記載する）
        self.delegate.closeMenuStatus(status: MenuStatus.closed)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
