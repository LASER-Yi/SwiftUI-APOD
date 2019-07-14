//
//  Header.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/14.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WfHeader: View {
    
    var currentDateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd"
        return formatter.string(from: .init())
    }
    
    var reloadFunc: () -> ()
    
    @EnvironmentObject var userData: UserData
    
    @State var btnAngle = 180.0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(currentDateStr.uppercased())
                .font(.subheadline)
                .bold()
                .color(.gray)
            
            HStack {
                Text("APOD")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    self.reloadFunc()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .imageScale(.large)
                        .rotationEffect(Angle(degrees: userData.isLoading ? btnAngle : 0))
                        .animation(.basic())
                        .disabled(userData.isLoading == true)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                if self.userData.isLoading {
                                    self.btnAngle += 12.0
                                }else {
                                    self.btnAngle = 180.0
                                }
                                
                                self.btnAngle.formTruncatingRemainder(dividingBy: 360.0)
                            }
                        }
                }
            }
            
            Divider()
        }
        .padding()
        
    }
}

#if DEBUG
struct Header_Previews : PreviewProvider {
    static var previews: some View {
        WfHeader(reloadFunc: {})
            .environmentObject(UserData.test)
    }
}
#endif
