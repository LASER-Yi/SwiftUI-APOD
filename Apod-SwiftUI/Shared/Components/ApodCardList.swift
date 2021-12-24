//
//  ApodCardList.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

struct ApodCardList<EmptyListView: View> : View {
    
    @State var models: [ApodData]
    
    private var emptyView: EmptyListView
    
    @State var emptyMessage: String = ""
    
    init(models: [ApodData], @ViewBuilder content: () -> EmptyListView) {
        self._models = State(initialValue: models)
        self.emptyView = content()
    }
    
    var body: some View {
        LazyVStack {
            if models.isEmpty {
                emptyView
            }else {
                ForEach(models) { item in
                    ApodCard(apod: item)
                        .padding([.top, .bottom])
                }
            }
        }
    }
}


#if DEBUG
struct ApodCardList_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView{
                ApodCardList(models: debugApodList) {
                    Placeholder(sfSymbol: "bin.xmark.fill", content: nil)
                }
            }
        }
    }
}
#endif
