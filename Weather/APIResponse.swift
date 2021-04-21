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
        let body: NowBody
        
    enum CodingKeys: String, CodingKey {
        case header, body
    }
}
struct TownData: Codable {
    let header: Header
    let body: TownBody
    
    enum CodingKeys: String, CodingKey {
        case header, body
    }
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
}

struct NowInfo: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let nx: Int
    let ny: Int
    let obsrValue: String
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
            case 0...5:
                state = "오늘은 맑아요! 산책 쌉가능"
                //return
            case 6...8:
                state = "구름이 많아요! 산책 가능"
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
            case 0...5:
                state = "맑음"
                //return
            case 6...8:
                state = "조금 흐림"
            default:
                state = "흐림"
            }
        }
        return state
    }
    
    var fcstDateSubStr: String {
        var firstIdx: String.Index = fcstDate.index(fcstDate.startIndex, offsetBy: 4)
        var endIdx: String.Index = fcstDate.index(fcstTime.startIndex, offsetBy: 6)
        let mon = String(fcstDate[firstIdx..<endIdx])
        firstIdx = fcstDate.index(fcstDate.startIndex, offsetBy: 6)
        endIdx = fcstDate.index(fcstDate.startIndex, offsetBy: 8)
        let day = String(fcstDate[firstIdx..<endIdx])
        
        return mon+"/"+day
    }
    var fcstTimeSubStr: String {
        let endIdx: String.Index = fcstTime.index(fcstTime.startIndex, offsetBy: 2)

        var result = String(fcstTime[..<endIdx])
        return result+"시"
    }
    
}

