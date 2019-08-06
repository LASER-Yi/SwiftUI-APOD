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
    
    public init(type: LoadType) {
        self.type = type
    }
    
    enum LoadType {
        case refresh
        case append
    }
    
    let type: LoadType
    
    private var delegate: [RequestDelegate] = []
    
    mutating func bindingDelegate(_ delegate: RequestDelegate) {
        self.delegate.append(delegate)
    }
    
    func boardcastSuccess(_ apods: [ApodBlockData]) {
        delegate.forEach { (delegate) in
            delegate.requestSuccess(apods, type)
        }
    }
    
    func boardcastFailure(_ error: RequestError) {
        delegate.forEach { (delegate) in
            delegate.requestError(error)
        }
    }
    
    // API Part
    var date: Date?
    var concept_tags: Bool? // turn off
    var hd: Bool?
    var count: Int?
    var start_date: Date?
    var end_date: Date?
    var thumbs: Bool?
    var api_key: String = UserSetting.shared.apiKey
    
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
    
    enum RequestError: Error {
        case UrlError(_ error: URLError)
        case Other(_ str: String)
        case Empty
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
    
    func sendRequest() -> some AnyCancellable
    // where S: Subscriber, S.Failure == RequestError, S.Input == [ApodResult]
    {
        let header = makeRequestHeader().map { (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        }
        
        var components = URLComponents(url: Self.requestUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = header
        
        guard let url = components?.url else { fatalError("request url wrong")}
        
        var request = URLRequest(url: url);
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTaskPublisher(for: request)
            .mapError({ (error) -> RequestError in
                RequestError.UrlError(error)
            })
            .tryMap({ (data, response) in
                var results: [ApodResult] = []
                let decoder = JSONDecoder()
                
#if DEBUG
                print(String(data: data, encoding: .utf8)!)
#endif
                
                if let array = try? decoder.decode(Array<ApodResult>.self, from: data) {
                    results.append(contentsOf: array)
                }else if let single = try? decoder.decode(ApodResult.self, from: data) {
                    results.append(single)
                }else if let error = try? decoder.decode(ApodResult.ApodError.self, from: data){
                    throw RequestError.Other(error.msg)
                }else if let error = try? decoder.decode([String: ApodResult.ApodError].self, from: data) {
                    throw RequestError.Other(error.first!.value.msg)
                }else {
                    throw RequestError.Other("Unknown Error")
                }
                
                return results
            })
            .mapError({ error in
                error as! RequestError
            })
            .sink(receiveCompletion: { (completion) in
                
                switch completion {
                case .failure(let error):
                    self.boardcastFailure(error)
                default:
                    break
                }
                
            })
            { (input: [ApodResult]) in
                let block: [ApodBlockData] = input.map { (result) -> ApodBlockData in
                    ApodBlockData(content: result)
                }
                
                self.boardcastSuccess(block)
            }
            
        
        return task
    }
}

protocol RequestDelegate {
    func requestError(_ error: ApodRequest.RequestError)
    
    func requestSuccess(_ apods: [ApodBlockData], _ type: ApodRequest.LoadType)
}
