//
//  ContentView.swift
//  ImageUploadTemplate
//
//  Created by Alex Rodriguez on 5/23/20.
//  Copyright © 2020 Alex Rodriguez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: FirebaseSession
    @State private var showImagePicker: Bool = false
    @State private var image : Image? = nil
    
    var body: some View {
        NavigationView {
            Group {
                if session.session != nil {
                    VStack(alignment: .leading,spacing: 0) {
                        GeometryReader { (geometry) in
                            self.makeGridView(geometry)
                        }
                        Spacer()
                        HStack(alignment: .bottom){
                            Group {
                                Spacer()
                                Button(action: {
                                    self.showImagePicker = true
                                }) {
                                    Image(systemName: "icloud.and.arrow.up").frame(width: 50, height: 50, alignment: .center).opacity(1).font(Font.system(.largeTitle)).foregroundColor(Color.blue)
                                }
                                Spacer()
                            }.frame(maxWidth: .infinity).shadow(radius: 5, y: -20)
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).navigationBarItems(trailing: Button(action: {
                        self.session.logOut()
                    }) {
                        Text("Logout")
                    })
                    .navigationBarTitle("Limit<")
                    
                } else {
                    LoginView()
                    .navigationBarItems(trailing: Text(""))
                }
            }.background(Color.white)
        }.sheet(isPresented: self.$showImagePicker) {
            PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image).environmentObject(self.session)
        }
        .onAppear(perform: getUser)
    }
    
    func makeGridView(_ geometry: GeometryProxy) -> some View {
        print(geometry.size.width, geometry.size.height)
        
        var splitImages: [[UIImage]] = []
        var counter = 1;
        var curRow: [UIImage] = []
        print("image count")
        print(self.session.imageThumbnails.count)
        for index in 0..<self.session.imageThumbnails.count {
            if counter < 5 {
                curRow.append(self.session.imageThumbnails[index])
                counter+=1
                if (index == self.session.imageThumbnails.count-1) {
                    splitImages.append(curRow)
                }
            } else {
                counter=0
                splitImages.append(curRow)
                curRow = [self.session.imageThumbnails[index]]
            }
        }
        print("There is something:L")
        print(splitImages)

        return ScrollView{VStack(alignment: .leading, spacing: 0) {
            ForEach(splitImages, id:\.self) { (row) in
                HStack(alignment: .top, spacing: 0) {
                    ForEach(row, id:\.self) { (image) in
                        GridThumbnail(image: image, width: geometry.size.width/4, height:geometry.size.width/4)
                    }
                }
            }
        }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)}.offset(x:0,y:1)
    }
    
    func getUser() {
        session.listen()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
