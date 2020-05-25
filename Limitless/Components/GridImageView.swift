//
//  GridImageView.swift
//  Limitless
//
//  Created by Alex Rodriguez on 5/24/20.
//  Copyright © 2020 Zankner Rodriguez. All rights reserved.
//

import SwiftUI

struct GridImageView: View {
    var geometry: GeometryProxy
    @Binding var splitImages: [[Thumbnail]]
    @Binding var selected_images: [String]
    var body: some View {
        ScrollView{VStack(alignment: .leading, spacing: 0) {
            ForEach(self.splitImages, id: \.self) { (row) in
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(row,  id: \.self) { (thumb) in
                            self.build_button(thumb: thumb)
                            
//                            GridThumbnail(thumb: thumb, width: self.geometry.size.width/4-7, height:self.geometry.size.width/4-7) { () in
//
//                            }
                        }
                    }
                }
        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)}.offset(x:0,y:1)
    }
    
    func build_button(thumb: Thumbnail) -> some View{
        Button(action: {
            print("Calling button action")
            for row in self.splitImages {
                let index_r = self.splitImages.firstIndex(of: row)
                for item in row {
                    let index_i = row.firstIndex(of: item)
                    if item.key == thumb.key {
                        var newthm = Thumbnail(key: item.key, image: item.image)
                        newthm.selected = !item.selected
                        self.splitImages[index_r!][index_i!] = newthm
                    }
                }
            }
            if thumb.selected == true {
                if let index = self.selected_images.firstIndex(of: thumb.key) {
                     self.selected_images.remove(at: index)
                    thumb.selected == false
                }
            } else {
                self.selected_images.append(thumb.key)
                thumb.selected == true
            
            }
        }) {
            if thumb.selected == true {
                Image(uiImage: thumb.image)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: self.geometry.size.width/4-7, height: self.geometry.size.width/4-7, alignment: .center)
                    .clipped()
                    .cornerRadius(12)
                    .padding(4)
                    .overlay(SelectionOverlay(), alignment: .topTrailing)
            } else {
                Image(uiImage: thumb.image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                    .frame(width: self.geometry.size.width/4-7, height: self.geometry.size.width/4-7, alignment: .center)
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

