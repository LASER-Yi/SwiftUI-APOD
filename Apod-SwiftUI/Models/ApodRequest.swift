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
    
    typealias Publisher = AnyPublisher<[ApodData], RequestError>
    
    enum RequestError: Error {
        case UrlError(_ error: URLError)
        case Other(_ str: String)
        case Empty
    }
    
    static private let url: URL = URL(string: "https://api.nasa.gov/planetary/apod")!
    
    // MARK: - Static
    static var today: ApodRequest {
        var req = ApodRequest()
        req.date = .init()
        
        return req
    }
    
    // MARK: - API
    var date: Date?
    var concept_tags: Bool? // turn off
    private var hd: Bool = UserSetting.shared.loadHdImage
    var count: Int?
    var start_date: Date?
    var end_date: Date?
    var thumbs: Bool?
    private var api_key: String = UserSetting.shared.apiKey
    
    private enum ReflectionKey: String {
        case date
        case concept_tags
        case hd
        case count
        case start_date
        case end_date
        case thumbs
        case api_key
    }
    
    private var formatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }
    
    private var form: [String: String] {
        var dic: [String: String] = [:]
        
        dic.updateValue(api_key, forKey: ReflectionKey.api_key.rawValue)
        dic.updateValue(hd.description, forKey: ReflectionKey.hd.rawValue)
        
        let dateFormat = self.formatter;
        
        if let date = self.date {
            dic.updateValue(dateFormat.string(from: date), forKey: ReflectionKey.date.rawValue)
        }
        if let count = self.count {
            dic.updateValue(count.description, forKey: ReflectionKey.count.rawValue)
        }
        if let startDate = self.start_date {
            dic.updateValue(dateFormat.string(from: startDate), forKey: ReflectionKey.start_date.rawValue)
        }
        if let endDate = self.end_date {
            dic.updateValue(dateFormat.string(from: endDate), forKey: ReflectionKey.end_date.rawValue)
        }
        if let thumbs = self.thumbs {
            dic.updateValue(thumbs.description, forKey: ReflectionKey.thumbs.rawValue)
        }
        if let conceptTags = self.concept_tags {
            dic.updateValue(conceptTags.description, forKey: ReflectionKey.thumbs.rawValue)
        }
        
        return dic
    }
    
    private var urlRequest: URLRequest {
        let header = self.form.map { URLQueryItem(name: $0, value: $1) }
        
        var components = URLComponents(url: Self.url, resolvingAgainstBaseURL: false)
        components?.queryItems = header

        guard let url = components?.url else { fatalError("request url wrong")}

        var request = URLRequest(url: url);
        request.httpMethod = "GET"
        
        return request
    }
    
    func request() -> Publisher {
        let task = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({ (error) -> RequestError in
                RequestError.UrlError(error)
            })
            .tryMap({ (data, response) -> [ApodData] in
                var results: [ApodData] = []
                let decoder = JSONDecoder()
                
                if let array = try? decoder.decode(Array<ApodData>.self, from: data) {
                    results.append(contentsOf: array)
                }else if let single = try? decoder.decode(ApodData.self, from: data) {
                    results.append(single)
                }else if let error = try? decoder.decode(ApodData.ApodError.self, from: data){
                    throw RequestError.Other(error.msg)
                }else if let error = try? decoder.decode([String: ApodData.ApodError].self, from: data) {
                    throw RequestError.Other(error.first!.value.msg)
                }else {
                    throw RequestError.Other("Unknown Error")
                }
                
                return results
            })
            .mapError({ error in
                error as! RequestError
            })
            
        
        return task.eraseToAnyPublisher()
    }
}
