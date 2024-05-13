//
//  Weather.swift
//  Muhammad_Weather
//
//  Created by MUS on 2020-11-16.
//

import Foundation

struct Weather: Codable, Identifiable{
    var id: String?
    var tempC: Double?
    var feelslikeC: Double?
    var dewpointC: Double?
    var humidity: Int?
    var windKPH: Int?
    var visibilityKM: Double?
    
    init() {
        id = nil
        tempC = 0.0
        feelslikeC = 0.0
        dewpointC = 0.0
        humidity = 0
        windKPH = 0
        visibilityKM = 0.0
    }
    
    enum CodingKeys: String, CodingKey{
        case response = "response"
        case id = "id"
        case ob = "ob"
        case tempC = "tempC"
        case feelslikeC = "feelslikeC"
        case dewpointC = "dewpointC"
        case humidity = "humidity"
        case windKPH = "windKPH"
        case visibilityKM = "visibilityKM"
    }
    
    init(from decoder: Decoder) throws {
        
        let response = try decoder.container(keyedBy: CodingKeys.self)
        let weatherResponse = try response.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        
        self.id = try weatherResponse.decodeIfPresent(String.self, forKey: .id)
        let ob = try weatherResponse.nestedContainer(keyedBy: CodingKeys.self, forKey: .ob)
        
        self.tempC = try ob.decodeIfPresent(Double.self, forKey: .tempC)
        self.feelslikeC = try ob.decodeIfPresent(Double.self, forKey: .feelslikeC)
        self.dewpointC = try ob.decodeIfPresent(Double.self, forKey: .dewpointC)
        self.humidity = try ob.decodeIfPresent(Int.self, forKey: .humidity)
        self.windKPH = try ob.decodeIfPresent(Int.self, forKey: .windKPH)
        self.visibilityKM = try ob.decodeIfPresent(Double.self, forKey: .visibilityKM)
    }
    func encode(to encoder: Encoder) throws {
        
    }
}
