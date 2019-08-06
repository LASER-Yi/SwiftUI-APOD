//
//  UserData.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine



final class UserData: ObservableObject {
    
    private init() {}
    
    static let shared = UserData()
    
    enum WfLabel: String, CaseIterable {
        case recent = "Recent"
        case random = "Random"
        case saved = "Saved"
    }
    
    @Published var localApods: [ApodBlockData] = []
    
    @Published var randomApods: [ApodBlockData] = []
    
    @Published var savedApods: [ApodBlockData] = []
    
    var selectedList: [ApodBlockData] {
        switch currentLabel {
        case .recent:
            return localApods
        case .random:
            return randomApods
        case .saved:
            return savedApods
        }
    }
    
    func sendOnlineRequest(delegate: RequestDelegate, type: ApodRequest.LoadType) {
        loadHandle?.cancel()
        self.isLoading = true
        
        var request = ApodRequest(type: type)
        
        request.bindingDelegate(delegate)
        request.bindingDelegate(self)
        
        request.hd = UserSetting.shared.loadHdImage

        if currentLabel == .random {
            request.count = 10
        }
        
        loadHandle = request.sendRequest()
    }
    
    @Published var currentLabel: WfLabel = .recent
    
    @Published var isLoading: Bool = false
    
    var loadHandle: AnyCancellable?
}

extension UserData: RequestDelegate {
    func requestError(_ error: ApodRequest.RequestError) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func requestSuccess(_ apods: [ApodBlockData], _ type: ApodRequest.LoadType) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    
}
