//
//  UserData.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: BindableObject, Subscriber {
    func receive(subscription: Subscription) {
        subscription.request(.max(1))
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        if let apod = input {
            serverData = apod
            return .none
        }
        return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        
    }
    
    typealias Input = ApodResult?
    
    typealias Failure = URLSession.DataTaskPublisher.Failure
    
    let didChange = PassthroughSubject<UserData, Never>()
    
    func requestApod() {
        var requestObj = ApodRequest(api_key: apiKey)
        requestObj.hd = true
        
        requestObj.makeRequest(subscriber: self)
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
    
    var serverData: ApodResult? = nil {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
}
