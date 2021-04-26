//
//  Network.swift
//  Weather
//
//  Created by jh on 2021/04/14.
//

import Foundation

struct Network {
    enum NetworkResult {
        case success(_ data: Data)
        case failed(_ error: Error)
    }

    static func request(urlPath: String, completion:@escaping (_ result: NetworkResult)->()) {

        guard let url: URL = URL(string: urlPath) else {return}

        let urlSession = URLSession.shared

        let task = urlSession.dataTask(with: url as URL) { (data, response, error) -> Void in
            error == nil ? completion(.success(data!)) : completion(.failed(error!))
        }
        task.resume()
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}


//http://apis.data.go.kr/1360000/VilageFcstInfoService
//getUltraSrtNcst 초단기실황
//getUltraSrtFcst 초단기예보
//getVilageFcst 동네 예보
//Enecoding
//dP56BeIkDFP%2Bpu3BL%2FBmJMGAzYIosy%2BBxZTykiTGKFxqT6%2FR7WPOAlHS4xzUhY1f7zdgU6HHkeX6iYl4aL8Wng%3D%3D
//Decoding
//dP56BeIkDFP+pu3BL/BmJMGAzYIosy+BxZTykiTGKFxqT6/R7WPOAlHS4xzUhY1f7zdgU6HHkeX6iYl4aL8Wng==


