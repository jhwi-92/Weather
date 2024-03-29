//
//  APIResponse.swift
//  Weather
//
//  Created by jh on 2021/04/14.
//

import Foundation

struct APIWeatherNowResponse: Codable {
    let nowWeatherResponse: NowResponse
}
struct APIWeatherTownResponse: Codable {
    let townWeatherResponse: TownResponse
}

struct NowResponse: Codable {
    let response: NowData
}
struct TownResponse: Codable {
    let response: TownData
}
struct NowData: Codable {
//    struct Movie: Codable {
        let header: Header
        let body: NowBody?
        
    enum CodingKeys: String, CodingKey {
        case header, body
    }
}
struct TownData: Codable {
    let header: Header
    let body: TownBody?
    
//    enum CodingKeys: String, CodingKey {
//        case header, body
//    }
}

struct Header: Codable {
    let resultCode: String
    let resultMsg: String
}

struct NowBody: Codable {
    let dataType: String
    let items: NowItem
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct NowItem: Codable {
    let item: [NowInfo]
    
    var TEM: [NowInfo] {
        var temData: [NowInfo] = []
        for i in item {
            if i.category == "T1H" {
                    //t3hData.insert(i, at: 0)
                temData.append(i)
            }
        }
        return temData
    }
    
    var PTY: [NowInfo] {
        var ptyData: [NowInfo] = []
        for i in item {
            if i.category == "PTY" {
                ptyData.append(i)
            }
        }
        return ptyData
    }
    
}

struct NowInfo: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let nx: Int
    let ny: Int
    let obsrValue: String
    
    
    //없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4), 빗방울(5), 빗방울/눈날림(6), 눈날림(7)
    //여기서 비/눈은 비와 눈이 섞여 오는 것을 의미 (진눈개비)
    var ptyState: String {
        var state: String = ""
        
        switch Int(obsrValue)! {
        case 0:
            state = "없음"
            //return
        case 1:
            state = "비"
        case 2:
            state = "비/눈"
        case 3:
            state = "눈"
        case 4:
            state = "소나기"
        case 5:
            state = "빗방울"
        case 6:
            state = "빗방울/눈날림"
        case 7:
            state = "눈날림"
            
        default:
            state = "???"
        }
        
        return state
    }
}
 
struct TownBody: Codable {
    let dataType: String
    let items: TownItem
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct TownItem: Codable {
    let item: [TownInfo]
    
    var SKY: [TownInfo] {
        var skyData: [TownInfo] = []
        for i in item {
            if i.category == "SKY" {
                    //t3hData.insert(i, at: 0)
                skyData.append(i)
            }
        }
        return skyData
    }
    
    var T3H: [TownInfo] {
        var t3hData: [TownInfo] = []
        for i in item {
            if i.category == "T3H" {
                    //t3hData.insert(i, at: 0)
                    t3hData.append(i)
            }
        }
        return t3hData
    }
    
    var TMN: [TownInfo] {
        var tmnData: [TownInfo] = []
        for i in item {
            if i.category == "TMN" {
                    //t3hData.insert(i, at: 0)
                tmnData.append(i)
            }
        }
        return tmnData
    }
    
    var TMX: [TownInfo] {
        var tmxData: [TownInfo] = []
        for i in item {
            if i.category == "TMX" {
                tmxData.append(i)
            }
        }
        return tmxData
    }
    
    var PTY: [TownInfo] {
        var ptyData: [TownInfo] = []
        for i in item {
            if i.category == "PTY" {
                ptyData.append(i)
            }
        }
        return ptyData
    }
}

struct TownInfo: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
    
    var skyStateComment: String {
        var state: String = ""
        if category == "SKY" {
            switch Int(fcstValue)! {
            case 0...1:
                state = "오늘은 맑아요! 산책 쌉가능"
                //return
            case 2:
                state = "구름이 조금! 산책 가능"
            case 3:
                state = "구름이 많아요! ㅇㅇ"
            default:
                state = "하늘이 흐려요! ㅜㅜ"
            }
        }
        return state
    }
    
    var skyState: String {
        var state: String = ""
        if category == "SKY" {
            switch Int(fcstValue)! {
            case 0...1:
                state = "맑음"
                //return
            case 2:
                state = "구름조금"
            case 3:
                state = "약간흐림"
            default:
                state = "흐림"
            }
        }
        return state
    }
    
    var ptyState: String {
        var state: String = ""
        
        switch Int(fcstValue)! {
        case 0:
            state = "없음"
            //return
        case 1:
            state = "비"
        case 2:
            state = "비/눈"
        case 3:
            state = "눈"
        case 4:
            state = "소나기"
        case 5:
            state = "빗방울"
        case 6:
            state = "빗방울/눈날림"
        case 7:
            state = "눈날림"
            
        default:
            state = "???"
        }
        
        return state
    }
    
    var fcstDateYear: String {
        var firstIdx: String.Index = fcstDate.index(fcstDate.startIndex, offsetBy: 0)
        var endIdx: String.Index = fcstDate.index(fcstTime.startIndex, offsetBy: 4)
        let year = String(fcstDate[firstIdx..<endIdx])
        return year
    }
    var fcstDateMon: String {
        var firstIdx: String.Index = fcstDate.index(fcstDate.startIndex, offsetBy: 4)
        var endIdx: String.Index = fcstDate.index(fcstTime.startIndex, offsetBy: 6)
        let mon = String(fcstDate[firstIdx..<endIdx])
        return mon
    }
    
    var fcstDateDay: String {
        var firstIdx = fcstDate.index(fcstDate.startIndex, offsetBy: 6)
        var endIdx = fcstDate.index(fcstDate.startIndex, offsetBy: 8)
        let day = String(fcstDate[firstIdx..<endIdx])
        return day
    }
    
    var fcstTimeSubStr: String {
        let endIdx: String.Index = fcstTime.index(fcstTime.startIndex, offsetBy: 2)

        var result = String(fcstTime[..<endIdx])
        return result+"시"
    }
    
}

