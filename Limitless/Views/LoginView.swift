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
    
     @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign In")
            TextField("Email", text: $email)
            
            SecureField("Password",text:$password)
            Button(action: logIn) {
                Text("Sign In")
            }.padding()
            NavigationLink(destination: SignUp()) {
                Text("Sign Up")
            }
            
        }.padding()
    }
    
    func logIn() {
        session.logIn(email:email, password: password) { (result, error) in
            if error != nil {
                print("Error")
                print(error)
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
