//
//  GridThumbnail.swift
//  ImageUploadTemplate
//
//  Created by Alex Rodriguez on 5/24/20.
//  Copyright © 2020 Alex Rodriguez. All rights reserved.
//

import SwiftUI

struct GridThumbnail: View {
    @Binding var thumb: Thumbnail
    var width: CGFloat
    var height: CGFloat
    var actionResponse: () -> Void
    
    var body: some View {
        Button(action: {
            print("Calling button action")
            self.thumb.selected = !self.thumb.selected
            self.actionResponse()
        }) {
            if self.thumb.selected == true {
                Image(uiImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height, alignment: .center)
                    .clipped()
                    .cornerRadius(12)
                    .padding(4)
                    .overlay(SelectionOverlay(), alignment: .topTrailing)
            } else {
                Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height, alignment: .center)
                .clipped()
                .cornerRadius(12)
                .padding(4)
            }
            
        }
    }
}

struct SelectionOverlay: View {
    var body: some View {
        ZStack {
            Image(systemName: "checkmark.circle.fill")
        }.background(Color.black)
        .foregroundColor(Color(hex:"fd0054"))
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(6)
        
    }
}

//struct GridThumbnail_Previews: PreviewProvider {
//    static var previews: some View {
//        GridThumbnail(UI)
//    }
//}
