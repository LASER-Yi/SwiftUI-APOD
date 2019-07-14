//
//  UserData.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

protocol ApodRequester {
    func handleRequestError(_ msg: String)
}

final class UserData: BindableObject {
    
    let didChange = PassthroughSubject<UserData, Never>()
    
    static let shared = UserData()
#if DEBUG
    static var test: UserData {
        let data = UserData()
        data.localApods = [testData]
        data.randomApods = testArray
        data.isLoading = false
        
        return data
    }
#endif
    
    var apiKey: String = "DEMO_KEY" {
        didSet {
            didChange.send(self)
        }
    }
    
    var loadHdImage: Bool = true {
        didSet {
            didChange.send(self)
        }
    }
    
    var localApods: [ApodResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
                self.updateSaved()
            }
        }
    }
    
    var randomApods: [ApodResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
                self.updateSaved()
            }
        }
    }
    
    var savedApods: [ApodResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    
    func updateSaved() {
        let allLoaded = localApods + randomApods
        
        let allStar = allLoaded.filter { $0.favourite && savedApods.contains($0)}
        
        savedApods += allStar
    }
    
    enum ApodLoadType: String, CaseIterable {
        case recent = "Recent"
        case random = "Random"
        case saved = "Saved"
    }
    
    var loadType: ApodLoadType = .recent {
        didSet {
            self.requestApod()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    
    var savedSubscription: Subscription? = nil
    
    var requester: ApodRequester? = nil
    
    func requestApod(_ requester: ApodRequester? = nil) {
        self.isLoading = true
        self.requester = requester
        updateSaved()
        
        if self.loadType == .saved {
            // tempory
            self.isLoading = false
            if savedApods.isEmpty {
                requester?.handleRequestError("Empty")
            }
        }else {
            var requestObj = ApodRequest(api_key: apiKey)
            
            if loadHdImage {
                requestObj.hd = true
            }
            
            if self.loadType == .random {
                requestObj.count = 10
            }
            
            requestObj.sendRequest(subscriber: self)
        }
    }
}

extension UserData: Subscriber {
    
    func receive(subscription: Subscription) {
        savedSubscription?.cancel()
        
        subscription.request(.max(1))
        
        savedSubscription = subscription
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        if self.loadType == .recent {
            localApods = input
        }else if self.loadType == .random {
            randomApods = input
        }
        
        self.isLoading = false
        
        if input.count == 0 {
            return .max(1)
        }else {
            return .none
        }
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        
        switch completion {
        case .finished:
            requester = nil
        case .failure(.UrlError(let error)):
            requester?.handleRequestError("Network Error, Code: \(error.code)")
        case .failure(.other(let errorStr)):
            requester?.handleRequestError(errorStr)
        }
        
        self.isLoading = false
        
    }
    
    typealias Input = [ApodResult]
    
    typealias Failure = ApodRequest.RequestError
}
