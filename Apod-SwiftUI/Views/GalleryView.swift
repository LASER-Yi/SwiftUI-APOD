//
//  GalleryView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import SwiftUI

struct GalleryView: View {
    
    enum Mode: String, CaseIterable, Identifiable {
        case Random
        case Time
        
        var id: String { self.rawValue }
        
        var systemName: String {
            switch self {
            case .Random:
                return "square.dashed.inset.filled"
            case .Time:
                return "timelapse"
            }
        }
    }
    
    @EnvironmentObject var runtime: RuntimeData
    
    @Environment(\.loading) var isLoading: Bool;
    
    @State var mode: Mode = .Random
    
    var source: ApodList {
        switch mode {
        case .Random:
            return runtime.randoms
        case .Time:
            return runtime.time
        }
    }
    
    static let columnCount = 3
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: columnCount)
    
    var body: some View {
        NavigationView {
            LoadableContent(source: self.source) { data in
                GeometryReader  { geometry in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(data) { item in
                                let size = geometry.size.width / CGFloat(Self.columnCount)
                                
                                Tile(apod: item)
                                    .frame(width: size, height: size, alignment: .center)
                            }
                        }
                        
                        if isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            Button {
                                print("Loading")
                            } label: {
                                Text("Load More")
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle(Text("Gallery"))
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Picker("Mode", selection: self.$mode) {
                            ForEach(Mode.allCases) { mode in
                                HStack {
                                    Image(systemName: mode.systemName)
                                    Text(mode.rawValue)
                                }
                                .tag(mode)
                            }
                            
                        }
                    } label: {
                        Label(mode.rawValue, systemImage: mode.systemName)
                    }
                }
            }
        }
    }
}

struct RandomView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
            .previewed()
    }
}
