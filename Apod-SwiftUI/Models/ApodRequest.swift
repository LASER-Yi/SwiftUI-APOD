//
//  ApodRequest.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation
import Combine

enum RequestError: Error {
    case EmptyResult
    case API(String)
    case Unknown(String)
}

class TodayApod: LoadableObject {
    @Published var state: Loadable<ApodData> = .notRequested
    
    private var request: ApodRequest {
        var req = ApodRequest()
        req.date = .init()
        
        return req
    }
    
    func load() {
        cancel()
        let last = state.value
        
        let cancelable = request.run()
            .map { data in
                if let first = data.first {
                    return Result.loaded(first)
                } else {
                    return Result.failed(last: last, RequestError.EmptyResult)
                }
            }
            .catch { error in
                Just(Result.failed(last: last, RequestError.Unknown(error.localizedDescription)))
            }
            .sink { [weak self] state in
                DispatchQueue.main.sync {
                    self?.state = state
                }
            }
        
        state = .isLoading(last: last, cancelable)
    }
}

class RandomApod: LoadableObject {
    @Published var state: Loadable<[ApodData]> = .notRequested
    
    enum LoadType {
        case Append
        case Refresh
    }
    
    let count = 10
    
    private var request: ApodRequest {
        var req = ApodRequest()
        req.count = count
        
        return req
    }
    
    func load() {
        loadInternal()
    }
    
    func reload() {
        loadInternal(with: .Refresh)
    }
    
    private func loadInternal(with loadType: LoadType = .Append) {
        cancel()
        let last = state.value
        
        let cancelable = request.run()
            .map { data in
                if loadType == .Append {
                    var newValue = last ?? []
                    newValue.append(contentsOf: data)
                    return Result.loaded(newValue)
                } else {
                    return Result.loaded(data)
                }
                
            }
            .catch { error in
                Just(Result.failed(last: last, RequestError.Unknown(error.localizedDescription)))
            }
            .sink { [weak self] state in
                DispatchQueue.main.sync {
                    self?.state = state
                }
            }
        
        state = .isLoading(last: last, cancelable)
    }
}

struct ApodRequest {
    
    typealias Publisher = AnyPublisher<[ApodData], Error>
    
    // MARK: - API
    var date: Date?
    var concept_tags: Bool? // turn off
    var count: Int?
    var start_date: Date?
    var end_date: Date?
    var thumbs: Bool?
    private var hd: Bool = UserSettings.shared.loadHdImage
    private var api_key: String = UserSettings.shared.apiKey
    
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
        df.dateFormat = "yyyy-MM-dd"
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
        
        var components = URLComponents(url: Constants.NasaAPI, resolvingAgainstBaseURL: false)
        components?.queryItems = header
        
        guard let url = components?.url else { fatalError("request url wrong")}
        
        var request = URLRequest(url: url);
        request.httpMethod = "GET"
        
        return request
    }
    
    func run() -> Publisher {
        let task = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data, response) -> [ApodData] in
                var results: [ApodData] = []
                let decoder = JSONDecoder()
                
                if let array = try? decoder.decode(Array<ApodData>.self, from: data) {
                    results.append(contentsOf: array)
                }else if let single = try? decoder.decode(ApodData.self, from: data) {
                    results.append(single)
                }else if let error = try? decoder.decode(ApodData.ApodError.self, from: data){
                    throw RequestError.API(error.msg)
                }else if let error = try? decoder.decode([String: ApodData.ApodError].self, from: data) {
                    throw RequestError.API(error.first?.value.msg ?? "Unknown error")
                }else {
                    throw RequestError.Unknown("Cannot parse results")
                }
                
                return results
            })
        
        return task.eraseToAnyPublisher()
    }
}
