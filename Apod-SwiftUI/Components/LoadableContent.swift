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
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear(perform: source.load)
            case let .isLoading(last: last, _):
                if let data = last {
                    content(data)
                        .environment(\.loading, true)
                } else {
                    ProgressView("Loading")
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
    
    class PreviewObject: LoadableObject {
        var state: Loadable<Bool>
        
        init(_ state: Loadable<Bool>) {
            self.state = state
        }
        
        func load() { }
    }
    
    static var previews: some View {
        Group {
            LoadableContent(source: PreviewObject(.notRequested)) { item in
                Text("Content")
            }
            
            LoadableContent(source: PreviewObject(.loaded(false))) { item in
                Text("Content")
            }
            
            LoadableContent(source: PreviewObject(.failed(last: false, URLError(.cannotFindHost)))) { item in
                Text("Content")
            }
        }
        .previewLayout(.sizeThatFits)
    }
}
