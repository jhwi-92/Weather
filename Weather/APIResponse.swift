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
    
    var skyState: String {
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
    
}

