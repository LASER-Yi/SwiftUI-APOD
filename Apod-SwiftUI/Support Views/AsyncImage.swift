//
//  AsyncImage.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

struct AsyncImage: View {
    let url: URL
    
    @Binding var isLoaded: Bool
    
    @State private var image: UIImage? = nil
    
    @State private var loadTask: AnyCancellable? = nil
    
    var body: some View {
        VStack {
            if image == nil {
                EmptyView()
            }else {
                Image(uiImage: image!)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .animation(.basic())
            }
            
        }
        .onAppear {
            self.loadImage()
        }
        .onDisappear {
            self.loadTask?.cancel()
        }
    }
    
    func loadImage() {
        loadTask = URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in
                return UIImage(data: data)
            }
            .replaceError(with: nil)
            .assign(to: \.image, on: self)
    }
}

#if DEBUG
struct AsyncImage_Previews : PreviewProvider {
    static var previews: some View {
        AsyncImage(url: URL(string: "https://img3.doubanio.com/view/status/l/public/4dc4add0fd63152.jpg")!, isLoaded: .constant(false))
            .frame(width: 300, height: 300)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}
#endif
