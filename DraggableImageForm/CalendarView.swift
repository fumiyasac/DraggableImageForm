//
//  CalendarView.swift
//  DraggableImageForm
//
//  Created by 酒井文也 on 2016/12/25.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

//カレンダー配置用ボタンを作成する構造体
struct CalendarView {
    
    //現在日付のカレンダー一覧を取得する
    static func getCalendarOfCurrentButtonList() -> [UIButton] {
        
        //年・月・最後の日を取得
        let values: (year: Int, month: Int, max: Int) = getCalendarOfCurrentValues()
        let year  = values.year
        let month = values.month
        let max   = values.max

        //ボタンの一覧を入れるための配列
        var buttonArray: [UIButton] = []
        
        //祝祭日判定用のインスタンス
        let holiday = CalculateCalendarLogic()
        
        for i in 1...max {

            //カレンダー選択用ボタンを作成する
            let button: UIButton = UIButton()
            
            //祝祭日の判定を行う
            let holidayFlag = holiday.judgeJapaneseHoliday(year: year, month: month, day: i)
            
            //曜日の数値を取得する（0:日曜日 ... 6:土曜日）
            let weekday = Weekday.init(year: year, month: month, day: i)
            let weekdayValue = weekday?.rawValue
            let weekdayString = weekday?.englishName
            
            //タグと日付の設定を行う
            button.setTitle(weekdayString! + "\n" + String(i), for: UIControl.State())
            button.titleLabel!.font = UIFont(name: "Arial", size: 12)!
            button.titleLabel!.numberOfLines = 2
            button.titleLabel!.textAlignment = .center
            button.tag = i
            
            //日曜日or祝祭日の場合の色設定
            if weekdayValue! % 7 == 0 || holidayFlag == true {
                
                button.backgroundColor = UIColor(
                    red: CGFloat(0.831),
                    green: CGFloat(0.349),
                    blue: CGFloat(0.224),
                    alpha: CGFloat(1.0)
                )

            //土曜日の場合の色設定
            } else if weekdayValue! % 7 == 6 {
                
                button.backgroundColor = UIColor(
                    red: CGFloat(0.400),
                    green: CGFloat(0.471),
                    blue: CGFloat(0.980),
                    alpha: CGFloat(1.0)
                )

            //平日の場合の色設定
            } else {

                button.backgroundColor = UIColor.lightGray
            }

            //設定したボタンの一覧を配列に入れる
            buttonArray.append(button)
        }
        
        return buttonArray
    }
    
    //現在日付の年の値を取得する
    static func getCalendarOfCurrentYear() -> Int {
        
        let values: (year: Int, month: Int, max: Int) = getCalendarOfCurrentValues()
        return values.year
    }
    
    //現在日付の月の値を取得する
    static func getCalendarOfCurrentMonth() -> Int {
        
        let values: (year: Int, month: Int, max: Int) = getCalendarOfCurrentValues()
        return values.month
    }

    //現在日付の年・月・最後の日の情報を取得する
    fileprivate static func getCalendarOfCurrentValues() -> (year: Int, month: Int, max: Int) {
        
        //現在の日付を取得する
        let now = Date()
        
        //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range: NSRange = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in:NSCalendar.Unit.month, for: now)
        
        //最初にメンバ変数に格納するための現在日付の情報を取得する
        let comps: DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.weekday], from: now)
        
        //年・月・最後の日を取得
        return (Int(comps.year!), Int(comps.month!), Int(range.length))
    }
    
}
