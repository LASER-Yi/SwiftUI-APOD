//
//  ApodJson.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation
import Combine

struct ApodResult: Codable {
    var copyright: String?
    var date: Date
    var explanation: String
    var hdurl: URL?
    var mediaType: MediaType
    var version: String
    var title: String
    var url: URL?
    
    enum MediaType: String, Codable {
        case Image = "image"
        case Video = "video"
    }
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case copyright
        case date
        case explanation
        case hdurl
        case version = "service_version"
        case title
        case url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try values.decode(String.self, forKey: CodingKeys.title)
        self.copyright = try? values.decode(String.self, forKey: CodingKeys.copyright)
        
        let strDate = try values.decode(String.self, forKey: CodingKeys.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        self.date = formatter.date(from: strDate) ?? Date()
        
        self.explanation = try values.decode(String.self, forKey: CodingKeys.explanation)
        
        self.hdurl = try? values.decode(URL.self, forKey: CodingKeys.hdurl)
        self.url = try? values.decode(URL.self, forKey: CodingKeys.url)
        
        self.version = try values.decode(String.self, forKey: CodingKeys.version)
        self.mediaType = try values.decode(MediaType.self, forKey: CodingKeys.mediaType)
    }
}

struct ApodRequest {
    var date: Date?
    var concept_tags: Bool? // turn off
    var hd: Bool?
    var count: Int?
    var start_date: Date?
    var end_date: Date?
    var thumbs: Bool?
    var api_key: String
    
    static let requestUrl: URL = URL(string: "https://api.nasa.gov/planetary/apod")!
    
    var formatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-DD"
        return df
    }
    
    private func makeRequestHeader() -> [String: String] {
        var dic: [String: String] = [:]
        //let reflection = Mirror(reflecting: self);
        dic.updateValue("api_key", forKey: api_key)
        
        
        
        return dic
    }
    
    func makeRequest(_ subscriber: AnySubscriber<ApodResult?, URLSession.DataTaskPublisher.Failure>) {
        var request = URLRequest(url: Self.requestUrl);
        let header = makeRequestHeader()
        request.allHTTPHeaderFields = header
        
//        header.forEach { (pair) in
//            let (key, value) = pair
//            request.addValue(value, forHTTPHeaderField: key)
//        }
        URLSession.shared.dataTaskPublisher(for: request)
            .map { (data, response) -> ApodResult? in
                let decoder = JSONDecoder()
                return try? decoder.decode(ApodResult.self, from: data)
            }
            .receive(subscriber: subscriber)
    }
}

#if DEBUG

let testApodStr: String = """
{"concepts":"concept_tags functionality turned off in current service","copyright":"Leonardo Caldas","date":"2019-07-09","explanation":"What do birds do during a total solar eclipse? Darkness descends more quickly in a total eclipse than during sunset, but returns just as quickly -- and perhaps unexpectedly  to the avians -- just a few minutes later. Stories about the unusual behavior of birds during eclipses have been told for centuries, but bird reactions were recorded and studied systematically by citizen scientists participating in an eBird project during the total solar eclipse that crossed the USA in 2017 August.  Although some unusual behaviors were observed, many observers noted birds acting like it was dusk and either landing or flying low to the ground.  Radar confirmed a significant decrease in high-flying birds and insects during and just after totality.  Conversely, several sightings of normally nocturnal birds were reported.  Pictured, a flock of birds in La Serena, Chile flew through the air together during the total solar eclipse that crossed South America last week. The photographer captured the scene in frames from an eclipse video.  The next total solar eclipse in 2020 December will also cross South America, while in 2024 April a total solar eclipse will cross North America from Mexico through New England, USA.   Gallery 2019: Notable total eclipse images submitted to APOD","hdurl":"https://apod.nasa.gov/apod/image/1907/BirdsEclipse_Caldas_3240.jpg","media_type":"image","service_version":"v1","title":"Birds During a Total Solar Eclipse","url":"https://apod.nasa.gov/apod/image/1907/BirdsEclipse_Caldas_960.jpg"}
"""

var decoder = JSONDecoder();

let testData = try! decoder.decode(ApodResult.self, from: testApodStr.data(using: .utf8)!)
#endif
