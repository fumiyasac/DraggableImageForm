//
//  ViewController.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/02.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//メニュー部分の開閉状態管理用のenum
enum MenuStatus {
    case opened
    case closed
}

class ViewController: UIViewController, MenuOpenDelegate, MenuCloseDelegate {
    
    //各種パーツのOutlet接続
    @IBOutlet weak var mainMenuContainer: UIView!
    @IBOutlet weak var subMenuContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DEBUG: このViewControllerの子ViewControllerの順番(index)を調べる
        //for (_, vc) in self.childViewControllers.enumerated() {
        //    print(vc)
        //}
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //矩形のままでアニメーションをさせるためにコードで再配置する
        mainMenuContainer.frame = CGRect(
            x: 0,
            y: 0,
            width: mainMenuContainer.frame.width,
            height: mainMenuContainer.frame.height
        )
        subMenuContainer.frame = CGRect(
            x: 0,
            y: 0,
            width: subMenuContainer.frame.width,
            height: subMenuContainer.frame.height
        )
    }
    
    /**
     * 複雑な遷移時のプロトコルの適用
     *
     * (Case1)
     * UINavigationController → 任意のViewControllerとStoryBoardで設定した際に、
     * 任意のViewControllerに定義したプロトコルを適用させる場合
     *
     * (Case2)
     * ContainerViewで接続された任意のViewControllerに対して、
     * 任意のViewControllerに定義したプロトコルを適用させる場合
     *
     * overrideしたprepareメソッドを利用する。
     * [Step1] それぞれの接続しているSegueに対してIdentifier名を定める
     * [Step2] 下記のidentifierに関連するViewControllerのインスタンスを取得してデリゲートを適用する
     * (UINavigationControllerの場合はちょっと注意)
     *
     * (参考): Containerとの値やり取り方法
     * http://qiita.com/BOPsemi/items/dd65b2b7cd83ec1e82b9
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MakeRecipe" {
            let navigationController = segue.destination as! UINavigationController
            let makeRecipeController = navigationController.viewControllers.first as! MakeRecipeController
            makeRecipeController.delegate = self
        }
        
        if segue.identifier == "Menu" {
            let menuController = segue.destination as! MenuController
            menuController.delegate = self
        }
    }

    /* MenuOpenDelegate */
    func openMenuStatus(status: MenuStatus) {
        changeMenuStatus(status)
    }

    /* MenuCloseDelegate */
    func closeMenuStatus(status: MenuStatus) {
        changeMenuStatus(status)
    }

    //enumの値に応じてのステータス変更を行う
    fileprivate func changeMenuStatus(_ targetStatus: MenuStatus) {
        
        if targetStatus == MenuStatus.opened {
            
            //メニューを表示状態にする
            UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                
                self.mainMenuContainer.isUserInteractionEnabled = false
                self.mainMenuContainer.frame = CGRect(
                    x: 0,
                    y: 240,
                    width: self.mainMenuContainer.frame.width,
                    height: self.mainMenuContainer.frame.height
                )

            }, completion: { finished in
                self.mainMenuContainer.alpha = 0.64
            })
            
        } else {
            
            //メニューを非表示状態にする
            self.mainMenuContainer.alpha = 1
            UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                
                self.mainMenuContainer.isUserInteractionEnabled = true
                self.mainMenuContainer.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: self.mainMenuContainer.frame.width,
                    height: self.mainMenuContainer.frame.height
                )

            }, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
