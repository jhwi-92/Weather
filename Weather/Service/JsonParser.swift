//
//  JsonParser.swift
//  Weather
//
//  Created by jh on 2021/04/28.
//

import Foundation

protocol JsonParserDelegate {
    func parsingDidFinished<T>(result: T, parsingType: JsonParser.ParsingType)
}

struct JsonParser {
 
    enum ParsingType {
            case town
            case now
    }
    
    var delegate: JsonParserDelegate? = nil
    
    func startParsing(data: Data, parsingType: ParsingType) {
        do {
            switch parsingType {
            case .now:
                let apiResponse: NowResponse = try JSONDecoder().decode(NowResponse.self, from: data)
                delegate?.parsingDidFinished(result: apiResponse, parsingType: parsingType)
            case .town:
                let apiResponse: TownResponse = try JSONDecoder().decode(TownResponse.self, from: data)
                delegate?.parsingDidFinished(result: apiResponse, parsingType: parsingType)
               
            }
        } catch (let err) {
            print(err)
        }
        
    }
    
    
}
