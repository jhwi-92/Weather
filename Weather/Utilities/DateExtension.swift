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
    func toTimeString(timeFormat format: String, type: String) -> String {
        let standardTime = [02, 05, 08, 11, 14, 17, 20, 23]
        let minTimeFormatter = DateFormatter()
        minTimeFormatter.dateFormat = "mm"
        minTimeFormatter.locale = Locale(identifier: "Ko_kr")
        let hourTimeFormatter = DateFormatter()
        hourTimeFormatter.dateFormat = format
        hourTimeFormatter.locale = Locale(identifier: "Ko_kr")
        let min = minTimeFormatter.string(from: self)
        var hour = hourTimeFormatter.string(from: self)
        if type == "getUltraSrtNcst" {
            if Int(min)! < 30 {
                hour = String(Int(hour)! - 1)
            }
            //return hour
        } else if type == "getVilageFcst" {
            //0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300
            //기상청 api가 해당시간 10분이 지나야 api생성됨.
            if Int(min)! < 10 {
                hour = String(Int(hour)! - 1)
            }
            
            var time = standardTime.filter({$0 <= Int(hour)!})
            
            hour = String(time.last!)
            print(time)
            //return hour
        }
        
        return hour
    }
    
    func weekday(year: Int, month: Int, day: Int) -> String? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "Ko_kr")
        
        guard let targetDate: Date = {
            let comps = DateComponents(calendar:calendar, year: year, month: month, day: day)
            return comps.date
            }() else { return nil }
        
        let day = Calendar.current.component(.weekday, from: targetDate) - 1
        
        return Calendar.current.shortWeekdaySymbols[day] // ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    //    return Calendar.current.standaloneWeekdaySymbols[day] // ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
    //    return Calendar.current.veryShortWeekdaySymbols[day] // ["S", "M", "T", "W", "T", "F", "S"]
    }
   
}
