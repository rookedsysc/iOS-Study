//
//  WeatherInformation.swift
//  WeatherApp
//
//  Created by Rookedsysc on 2022. 9. 13..
//

import Foundation


/* 자신을 변환하거나 외부 표현으로 변환할 수 있는 타입 (json과 같은 표현)
public typealias Codable = Decodable & Encodable
Decodable: (자신을 외부표현해서 Decoding 함)
Encodable: 자신을 외부 표현해서 Encoding 함 */
struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

// json 타입의 키와 사용자가 정의한 key와 타입이 일치해야 함
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
        
    // json 키와 사용자가 정의한 key가 달라도 mapping 될 수 있게 해줌
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
