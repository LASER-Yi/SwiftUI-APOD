//
//  UserData.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: BindableObject {
    
    let didChange = PassthroughSubject<UserData, Never>()
    
    init() {
#if DEBUG
        serverData = [testData]
        self.needReload = false
#endif
    }
    
    func requestApod() {
        var requestObj = ApodRequest(api_key: apiKey)
        requestObj.hd = true
        
        if self.loadType == .random {
            requestObj.count = 10
        }
        
        requestObj.makeRequest(subscriber: self)
        
        self.needReload = true
    }
    
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
    
    var serverData: [ApodResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    
    enum ApodLoadType: String, CaseIterable {
        case recent = "Recent"
        case random = "Random"
        //case saved = "Saved"
    }
    
    var loadType: ApodLoadType = .recent {
        didSet {
            self.requestApod()
        }
    }
    
    var needReload: Bool = true {
        didSet {
            if self.needReload {
                serverData = []
            }else {
                DispatchQueue.main.async {
                    self.didChange.send(self)
                }
            }
        }
    }
    
    var savedSubscription: Subscription? = nil
}

extension UserData: Subscriber {
    
    func receive(subscription: Subscription) {
        savedSubscription?.cancel()
        
        subscription.request(.max(1))
        
        savedSubscription = subscription
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        serverData = input
        self.needReload = false
        
        if serverData.count == 0 {
            return .max(1)
        }else {
            return .none
        }
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        self.needReload = false
    }
    
    typealias Input = [ApodResult]
    
    typealias Failure = URLSession.DataTaskPublisher.Failure
}
