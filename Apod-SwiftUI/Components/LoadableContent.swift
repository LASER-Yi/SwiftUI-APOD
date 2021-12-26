//
//  LoadableContent.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import SwiftUI

struct LoadingKey: EnvironmentKey {
    static var defaultValue: Bool {
        false
    }
}

extension EnvironmentValues {
    var loading: Bool {
        get {
            self[LoadingKey.self]
        }
        set {
            self[LoadingKey.self] = newValue
        }
    }
}

struct LoadableContent<Source: LoadableObject, Content: View>: View {
    
    @ObservedObject var source: Source
    var content: (Source.Output) -> Content
    
    init(source: Source, @ViewBuilder content: @escaping (Source.Output) -> Content) {
        self.source = source
        self.content = content
    }
    
    var body: some View {
        VStack {
            switch source.state {
            case .notRequested:
                ProgressView("Loading")
                    .onAppear(perform: source.load)
            case let .isLoading(last: last, _):
                if let data = last {
                    content(data)
                        .environment(\.loading, true)
                } else {
                    Text("Loading")
                }
            case .loaded(let data):
                content(data)
            case .failed(_, let err):
                Placeholder(sfSymbol: "sunset", content: err.localizedDescription)
            }
        }
        .onDisappear(perform: source.cancel)
        
    }
}

struct LoadableContent_Previews: PreviewProvider {
    static var previews: some View {
        LoadableContent(source: TodayApod()) { item in
            Text(item.formattedDate)
        }
    }
}