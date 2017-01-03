//
//  CustomTransition.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2017/01/04.
//  Copyright © 2017年 just1factory. All rights reserved.
//

import UIKit

class CustomTransition: NSObject, UIViewControllerAnimatedTransitioning {

    //トランジションの秒数
    let duration      = 0.18

    //トランジションの方向(present: true, dismiss: false)
    var presenting    = true

    //アニメーションの実体となるContainerViewのサイズ
    var originalFrame = CGRect.zero
    
    //アニメーションの時間を定義する
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /**
     * アニメーションの実装を定義する
     * この場合には画面遷移コンテキスト（UIViewControllerContextTransitioningを採用したオブジェクト）
     * → 遷移元や遷移先のViewControllerやそのほか関連する情報が格納されているもの
     */
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        //コンテキストを元にViewのインスタンスを取得する（存在しない場合は処理を終了）
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }

        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        //アニメーションの実態となるコンテナビューを作成
        let containerView = transitionContext.containerView

        //遷移先のViewController・始めと終わりのViewのサイズ・拡大値と縮小値を決定する
        var targetView: UIView!
        var initialFrame: CGRect!
        var finalFrame: CGRect!
        var xScaleFactor: CGFloat!
        var yScaleFactor: CGFloat!
        
        //Case1: 進む場合
        if presenting {

            targetView = toView
            initialFrame = originalFrame
            finalFrame = targetView.frame
            xScaleFactor = initialFrame.width / finalFrame.width
            yScaleFactor = initialFrame.height / finalFrame.height

        //Case2: 戻る場合
        } else {

            targetView = fromView
            initialFrame = targetView.frame
            finalFrame = originalFrame
            xScaleFactor = finalFrame.width / initialFrame.width
            yScaleFactor = finalFrame.height / initialFrame.height
        }

        //アファイン変換の倍率を設定する
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        //進む場合の遷移時には画面いっぱいに画像を表示させるようにする
        if presenting {
            targetView.transform = scaleTransform
            targetView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            targetView.clipsToBounds = true
        }

        //アニメーションの実体となるContainerViewに必要なものを追加する
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: targetView)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {

            //変数durationでの設定した秒数で拡大・縮小を行う
            targetView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            targetView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)

        }, completion:{ finished in
            transitionContext.completeTransition(true)
        })
    }
}
