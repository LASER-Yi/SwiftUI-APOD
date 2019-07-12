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
    
    @Binding var image: UIImage?
    
    @State var loadTask: AnyCancellable? = nil
    
    @State var imageName: String? = "arrow.down.square.fill"
    
    var body: some View {
        VStack {
            if image == nil {
                Placeholder(systemName: $imageName, showTitle: .constant(nil))
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
    
    func setInitalImage(_ image: UIImage) -> some View{
        self.image = image
        return self
    }
    
    private func loadImage() {
        let session = URLSession(configuration: .default)
        
        loadTask = session.dataTaskPublisher(for: url)
            .tryMap({ (data, response) -> UIImage in
                if let image = UIImage(data: data) {
                    return image
                }else {
                    throw URLError(.unknown)
                }
            })
            .catch{ error in
                return Just(nil)
            }
            .assign(to: \.image, on: self)
    }
}

#if DEBUG
struct AsyncImage_Previews : PreviewProvider {
    static var previews: some View {
        AsyncImage(url: URL(string: "https://img3.doubanio.com/view/status/l/public/4dc4add0fd63152.jpg")!, image: .constant(nil))
            .frame(width: 300, height: 300)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}
#endif
