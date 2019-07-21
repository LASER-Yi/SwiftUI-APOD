//
//  UserData.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

protocol RequestDelegate {
    func requestError(_ error: ApodRequest.RequestError)
}

final class UserData: BindableObject {
    
    let willChange = PassthroughSubject<UserData, Never>()
    
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
    
    var apiKey: String {
        set {
            willChange.send(self)
            UserDefaults.saveCustomValue(for: .ApiKey, value: newValue)
        }
        get {
            if let value = UserDefaults.getCustomValue(for: .ApiKey) as? String {
                return value
            }else {
                UserDefaults.saveCustomValue(for: .ApiKey, value: "DEMO_KEY")
                return "DEMO_KEY"
            }
        }
    }
    
    var loadHdImage: Bool {
        set {
            willChange.send(self)
            UserDefaults.saveCustomValue(for: .AutoHdImage, value: newValue)
        }
        get {
            if let value = UserDefaults.getCustomValue(for: .AutoHdImage) as? Bool {
                return value
            }else {
                UserDefaults.saveCustomValue(for: .AutoHdImage, value: true)
                return true
            }
        }
    }
    
    var localApods: [ApodResult] = [] {
        willSet {
            DispatchQueue.main.async {
                self.willChange.send(self)
            }
        }
    }
    
    var randomApods: [ApodResult] = [] {
        willSet {
            DispatchQueue.main.async {
                self.willChange.send(self)
            }
        }
    }
    
    var savedApods: [ApodResult] = [] {
        willSet {
            DispatchQueue.main.async {
                self.willChange.send(self)
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
        willSet {
            DispatchQueue.main.async {
                self.willChange.send(self)
            }
        }
    }
    
    var savedSubscription: Subscription? = nil
    
    var delegate: RequestDelegate? = nil
    
    func requestApod() {
        savedSubscription?.cancel()
        
        self.isLoading = true
        updateSaved()
        
        if self.loadType == .saved {
            // tempory
            self.isLoading = false
            if savedApods.isEmpty {
                delegate?.requestError(.Empty)
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
        case .failure(let error):
            delegate?.requestError(error)
        default:
            break
        }
        
        self.isLoading = false
        
    }
    
    typealias Input = [ApodResult]
    
    typealias Failure = ApodRequest.RequestError
}
