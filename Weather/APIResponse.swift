//
//  APIResponse.swift
//  Weather
//
//  Created by jh on 2021/04/14.
//

import Foundation

struct APIWeatherResponse: Codable {
    let weatherResponse: response
}

struct response: Codable {
    let response: responseData
}
struct responseData: Codable {
//    struct Movie: Codable {
        let header: Header
        let body: Body
        
    enum CodingKeys: String, CodingKey {
        case header, body
    }
//        var full: String {
//            return "평점 : " + String(self.userRating) + " 예매순위 : " + String(self.reservationGrade) + " 예매율 : " + String(self.reservationRate)
//        }
//
//        var gradeRatingRate: String {
//            return "\(self.reservationGrade)위(\(self.userRating)) / \(self.reservationRate)%"
//        }
//
//        var ageImageName: String {
//            switch grade {
//            case 12, 15, 19:
//                return "ic_"+String(grade)
//            default:
//                return "ic_allages"
//            }
//        }
}

struct Header: Codable {
    let resultCode: String
    let resultMsg: String
}

struct Body: Codable {
    let dataType: String
    let items: Item
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct Item: Codable {
    let item: [info]
}

struct info: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let nx: Int
    let ny: Int
    let obsrValue: String
}
 
