//
//  TodayView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/6/25.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI
import FancyScrollView

struct TodayView: View {
    
    @EnvironmentObject var runtime: RuntimeData
    
    let headerPadding = 50
    
    var body: some View {
        LoadableContent(source: runtime.today) { data in
            GeometryReader { screenGeometry in
                FancyScrollView(title: data.formattedDate, headerHeight: screenGeometry.size.height - CGFloat(headerPadding))  {
                    AsyncImage(url: data.imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        GeometryReader { geometry in
                            ProgressView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .background(Color.secondary)
                        }
                    }
                } content: {
                    VStack(alignment: .leading) {
                        Text(data.title)
                            .font(.title)
                            .bold()
                        
                        Divider()
                        
                        Text(data.explanation)
                            .font(.body)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                        
                        if let copyright = data.copyright {
                            Text("© \(copyright)")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
            }
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
