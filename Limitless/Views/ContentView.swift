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
    @State var selected_images: [String] = []
    @State var downloaded_images: [UIImage] = []
    @State var triggerSelectionView: Bool = false
    @State var splitImages: [[Thumbnail]] = []

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "150D1C").edgesIgnoringSafeArea(.all)
                
                if session.session != nil {
                    Group {
                        VStack(alignment: .leading,spacing: 0) {
                            GeometryReader { geometry in
                                GridImageView(geometry: geometry, splitImages: self.$splitImages, selected_images: self.$selected_images)
                            }.padding(.horizontal, 5).onAppear() {
                                    self.session.imageGraphicUpdate = { (key, image) in
                                        self.addImage(key: key, image: image)
                                        
                                    }
                                    self.downloaded_images = []
                            }
                            Spacer()
                            configureTabBar()
                            
                        }.padding(.top, 25).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading).navigationBarItems(trailing: Button(action: {
                            self.session.logOut()
                        }) {
                            Image(systemName: "arrowshape.turn.up.right.fill").resizable().frame(width: 35, height: 35, alignment: .center).foregroundColor(Color(hex:"fd0054"))
                        })
                        .navigationBarTitle(Text("Limit<").foregroundColor(Color(hex:"fd0054")))
                    }.background(RoundedCorners(color: Color(hex: "0B070F"), tl: 20, tr: 20, bl: 0, br: 0))
                        .onAppear() {
                    }
                
                } else {
                    LoginView()
                    .navigationBarItems(trailing: Text(""))
                }
               
            }
        }.sheet(isPresented: self.$showImagePicker) {
                PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image).environmentObject(self.session)
        }
        .onAppear() {
            self.getUser()
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:Color(hex:"fd0054").uiColor()]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:Color(hex:"fd0054").uiColor()]
        }
    }
    
    func configureTabBar() -> some View {
        let sendAction:() -> Void = {
            print("Implement send to friends")
        }
        let downloadAction:() -> Void = {
            self.session.downloadFullImageSet(iids: self.selected_images) { (image, final) in
                print("Adding image to downloaded cache")
                self.downloaded_images.append(image)
                if (final == true) {
                    print("Transitioning view")
                    self.triggerSelectionView = true
                    for row in self.splitImages {
                        let index_r = self.splitImages.firstIndex(of: row)
                        for item in row {
                            let index_i = row.firstIndex(of: item)
                            var newthm = Thumbnail(key: item.key, image: item.image)
                            self.splitImages[index_r!][index_i!] = newthm
                        }
                    }
                }
            }
            self.selected_images = []
        }
        return CustomTabBar(selected_images: $selected_images, sendAction: sendAction, downloadAction: downloadAction) { () in
            self.showImagePicker = true
        }
    }
    
//    ForEach(splitImages, id:\.self) { (row) in
//        HStack(alignment: .top, spacing: 0) {
//            ForEach(row.keys.sorted(),  id: \.self) { (key) in
//                GridThumbnail(image: row[key]!, key: key, width: geometry.size.width/4, height:geometry.size.width/4) { () in
//                    if self.selected_images.contains(key) {
//                        if let index = self.selected_images.firstIndex(of: key) {
//                            self.selected_images.remove(at: index)
//                        }
//                    } else {
//                        self.selected_images.append(key)
//                    }
//                }
//            }
//        }
//    }
    
//    func makeGridView() -> Void {
//        var counter = 0
//        var index = 0
//        var curRow: [String:UIImage] = [:]
//        var current_keys: [String] = []
//        self.splitImages = []
//        print("Images lengths")
//        print(self.session.imageThumbnails.keys.count)
//        for (key, value) in self.session.imageThumbnails {
//            if counter < 5 {
//                curRow[key] = value
//                counter+=1
//                if index == (self.session.imageThumbnails.keys.count-1) {
//                    print("reached the end!")
//                    self.splitImages.append(curRow)
//                }
//            } else {
//                counter=0
//                self.splitImages.append(curRow)
//                curRow = [:]
//                curRow[key] = value
//            }
//            index+=1
//        }
//        print("There is something:L")
//        print(splitImages)
//
//
//    }
    
    func addImage(key: String, image: UIImage) {
        var thumb = Thumbnail(key: key, image: image)
        if self.splitImages.count > 0 {
            if self.splitImages[self.splitImages.count-1].count < 4 {
                self.splitImages[self.splitImages.count-1].append(thumb)
                return
            }
            
        }
        print ("Adding new row!!!")
        var row: [Thumbnail] = []
        row.append(thumb)
        self.splitImages.append(row)
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

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
