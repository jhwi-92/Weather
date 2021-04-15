//
//  DateExtension.swift
//  Weather
//
//  Created by jh on 2021/04/15.
//

import Foundation

extension Date {
    func toDateString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        //dateFormatter.amSymbol = "오전"
        //dateFormatter.pmSymbol = "오후"
        //dateFormatter.timeZone = timezone
        dateFormatter.locale = Locale(identifier: "Ko_kr")
        return dateFormatter.string(from: self)
    }
    //기상청 api가 현재시간 30분이 지나야 api생성됨.
    //30분 전 현재시간 -1 api조회
    func toTimeString(timeFormat format: String) -> String {
        let minTimeFormatter = DateFormatter()
        minTimeFormatter.dateFormat = "mm"
        minTimeFormatter.locale = Locale(identifier: "Ko_kr")
        let min = minTimeFormatter.string(from: self)
        
        let hourTimeFormatter = DateFormatter()
        hourTimeFormatter.dateFormat = format
        hourTimeFormatter.locale = Locale(identifier: "Ko_kr")
        var hour = hourTimeFormatter.string(from: self)
        if Int(min)! < 30 {
            hour = String(Int(hour)! - 1)
        }
        return hour
    }
}
