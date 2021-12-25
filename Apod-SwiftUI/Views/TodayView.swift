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
    
    @EnvironmentObject var runtime: RuntimeData
    
    var body: some View {
        LoadableContent(source: runtime.today) { data in
            Article(content: data)
        }
    }
}

#if DEBUG
struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .previewed()
    }
}
#endif
