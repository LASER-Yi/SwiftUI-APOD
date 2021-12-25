//
//  PlaceholderList.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

struct PlaceholderList<V: View, C: View, D: Identifiable>: View {
    
    @State var models: [D]
    
    private let emptyBuilder: () -> V
    private let contentBuilder: (D) -> C
    
    init(models: [D], @ViewBuilder content: @escaping (D) -> C, @ViewBuilder placeholder: @escaping () -> V) {
        self._models = State(initialValue: models)
        self.contentBuilder = content
        self.emptyBuilder = placeholder
    }
    
    var body: some View {
        LazyVStack {
            if (models.isEmpty) {
                emptyBuilder()
            } else {
                ForEach(models) { item in
                    contentBuilder(item)
                }
            }
        }
    }
}

#if DEBUG
struct PlaceholderList_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ScrollView{
                PlaceholderList(models: debugContent) { item in
                    Card(apod: item)
                        .padding()
                } placeholder: {
                    Placeholder(sfSymbol: "bin.xmark.fill", content: nil)
                }
            }
        }
    }
}
#endif
