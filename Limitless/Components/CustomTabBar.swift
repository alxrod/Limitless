//
//  CustomTabBar.swift
//  Limitless
//
//  Created by Alex Rodriguez on 5/24/20.
//  Copyright © 2020 Zankner Rodriguez. All rights reserved.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selected_images: [String]
    var sendAction: () -> Void
    var downloadAction: () -> Void
    var uploadAction: () -> Void
    
    var body: some View {
        HStack(alignment: .bottom){
            if selected_images.count > 0 {
                Group {
                    Spacer()
                    Button(action: {
                        self.downloadAction()
                    }) {
                        
                        Image(systemName: "icloud.and.arrow.down").frame(width: 50, height: 50, alignment: .center).opacity(1).font(Font.system(.largeTitle)).foregroundColor(Color(hex:"fd0054"))
                    }.frame(height:60)
                    Spacer()
                }
            } else {
                Button(action: {
                    self.uploadAction()
                }) {
                    Spacer()
                    Image(systemName: "icloud.and.arrow.up").frame(width: 50, height: 50, alignment: .center).opacity(1).font(Font.system(.largeTitle)).foregroundColor(Color(hex:"fd0054"))
                    Spacer()
                }.frame(height:60)
    
            }
        }.background(Color(hex: "a80038")).frame(maxWidth: .infinity).shadow(radius: 4, x:0,y:-1)
    }
}

//struct CustomTabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabBar(selected_images: test_list){
//            print("all set")
//        }
//    }
//}
