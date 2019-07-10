//
//  ApodRequest.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation
import Combine

struct ApodRequest {
    var date: Date?
    var concept_tags: Bool? // turn off
    var hd: Bool?
    var count: Int?
    var start_date: Date?
    var end_date: Date?
    var thumbs: Bool?
    var api_key: String
    
    enum ReflectionKey: String {
        case date
        case concept_tags
        case hd
        case count
        case start_date
        case end_date
        case thumbs
        case api_key
    }
    
    static private let requestUrl: URL = URL(string: "https://api.nasa.gov/planetary/apod")!
    
    private var formatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }
    
    private func makeRequestHeader() -> [String: String] {
        var dic: [String: String] = [:]
        //let reflection = Mirror(reflecting: self);
        dic.updateValue(api_key, forKey: ReflectionKey.api_key.rawValue)
        
        let dateFormat = self.formatter;
        
        if let date = self.date {
            dic.updateValue(dateFormat.string(from: date), forKey: ReflectionKey.date.rawValue)
        }
        if let hd = self.hd {
            dic.updateValue(hd.description, forKey: ReflectionKey.hd.rawValue)
        }
        if let count = self.count {
            dic.updateValue(count.description, forKey: ReflectionKey.count.rawValue)
        }
        if let start_date = self.start_date {
            dic.updateValue(dateFormat.string(from: start_date), forKey: ReflectionKey.start_date.rawValue)
        }
        if let end_date = self.end_date {
            dic.updateValue(dateFormat.string(from: end_date), forKey: ReflectionKey.end_date.rawValue)
        }
        if let thumbs = self.thumbs {
            dic.updateValue(thumbs.description, forKey: ReflectionKey.thumbs.rawValue)
        }
        if let concept_tags = self.concept_tags {
            dic.updateValue(concept_tags.description, forKey: ReflectionKey.thumbs.rawValue)
        }
        
        return dic
    }
    
    func makeRequest<S>(subscriber: S) where S: Subscriber, S.Failure == URLSession.DataTaskPublisher.Failure, S.Input == ApodResult?
    {
        let header = makeRequestHeader().map { (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        }
        
        var components = URLComponents(url: Self.requestUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = header
        
        guard let url = components?.url else { fatalError("request url wrong")}
        
        var request = URLRequest(url: url);
        request.httpMethod = "GET"
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { (data, response) -> ApodResult? in
                let decoder = JSONDecoder()
                return try? decoder.decode(ApodResult.self, from: data)
        }
        .receive(subscriber: subscriber)
    }
}