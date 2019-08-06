//
//  ApodCardList.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

struct WfLoaderList : View {
    
    enum LoadMsgIcon: String {
        case loading = "cloud.rain"
        case empty = "tornado"
        case error = "cloud.bolt"
    }
    
    var apodType: UserData.WfLabel
    
    @Binding var contents: [ApodBlockData]
    
    @State var isError: Bool = false
    
    @State var errorMsg: String = ""
    
    var message: (LoadMsgIcon, String) {
        
        if UserData.shared.isLoading {
            return (LoadMsgIcon.loading, "loading")
        }else {
            if isError {
                return (LoadMsgIcon.error, errorMsg)
            }else {
                return (LoadMsgIcon.empty, "empty")
            }
        }
    }
    
    var body: some View {
        VStack{
            if contents.isEmpty {
                Placeholder(systemName: message.0.rawValue, showTitle: message.1.capitalized)
                    .padding(.top, 180)
                    .onAppear {
                        self.request()
                    }
            }else {
                ForEach(contents) { apod in
                    WfApodCard(block: apod)
                        .padding([.top, .bottom])
                }
                
                if apodType == .random {
                    Button(action: {
                        self.request(.append)
                    }) {
                        Text("More")
                    }
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width - 24)
    }
    
    func request(_ type: ApodRequest.LoadType = .refresh) {
        
        isError = false
        
        switch apodType {
        case .recent:
            fallthrough
        case .random:
            UserData.shared.loadHandle?.cancel()
            UserData.shared.isLoading = true
            UserData.shared.sendOnlineRequest(delegate: self, type: type)
        case .saved:
            break
        }
    }
}

extension WfLoaderList: RequestDelegate {
    func requestError(_ error: ApodRequest.RequestError) {
        isError = true
        
        switch error {
        case .Other(let msg):
            errorMsg = msg
            break
        case .UrlError(let error):
            errorMsg = error.localizedDescription
            break
        default:
            break
        }
    }
    
    func requestSuccess(_ apods: [ApodBlockData], _ type: ApodRequest.LoadType) {
        isError = false
        
        DispatchQueue.main.sync {
            switch type {
            case .refresh:
                contents = apods
            case .append:
                contents.append(contentsOf: apods)
            }
        }
    }
    
    
}

#if DEBUG
struct ApodCardList_Previews : PreviewProvider {
    static var previews: some View {
        ScrollView{
            WfLoaderList(apodType: .recent, contents: .constant([]))
        }
    }
}
#endif
