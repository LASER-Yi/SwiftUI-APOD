//
//  TodayView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/6/25.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

struct TodayView: View {
    
    @State fileprivate var apod: ApodData? = nil
    
    @State var error: String? = nil
    
    var request: ApodRequest.Publisher = ApodRequest.today.request()
    
    var body: some View {
        VStack {
            if let apod = self.apod {
                Article(content: apod)
                    .edgesIgnoringSafeArea(.top)
            } else {
                Placeholder(sfSymbol: "sunset", content: self.error)
            }
        }
    }
}

#if DEBUG
struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
#endif
