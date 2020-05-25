//
//  LoginView.swift
//  swiftUiTodos
//
//  Created by Alex Rodriguez on 5/23/20.
//  Copyright © 2020 Alex Rodriguez. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showAlert: Bool = false
    
     @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
       //Color(red: 0.83529411764, green: 0.8862745098, blue: 0.93333333333)
        VStack  {
            
            Text("Limit<").font(.largeTitle).fontWeight(.bold).foregroundColor(Color(hex:"fd0054"))
            Spacer()
//            Spacer()
            TextField("Email", text: $email)
                .multilineTextAlignment(.center).background(Color(hex:"0B070F")).foregroundColor(Color(hex:"#f5eded")).font(.title).frame(width: 350, height:60,alignment: .center).cornerRadius(10)

            
                SecureField("Enter a password", text: $password)
                    .multilineTextAlignment(.center).background(Color(hex:"0B070F")).foregroundColor(Color(hex:"#f5eded")).font(.title).frame(width: 300, height:60, alignment: .center).cornerRadius(10)
            Spacer()
//            Spacer()
            Button(action: {
                self.logIn()
            }) {
                Text("Sign In").foregroundColor(Color(hex:"fd0054"))
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Incorrect Username or Password"))
            }
            Spacer()
//            Spacer()
            Text ("Don't have an acount?").foregroundColor(Color(hex:"#f5eded"))
            
            
            VStack {
                    NavigationLink(destination: SignUp())
                    {
                        Text("Sign Up").foregroundColor(Color(hex:"fd0054"))
                                
                                
                }
            }
            Spacer()
            
           
        }
        
    }
    
    func logIn() {
        session.logIn(email:email, password: password) { (result, error) in
            if error != nil {
                print("Error")
                print(error)
                self.showAlert = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
