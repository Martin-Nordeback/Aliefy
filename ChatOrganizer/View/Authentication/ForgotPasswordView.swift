//
//  ForgotPasswordView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-05.
//
 // MARK: - OVERVIEW
///``Allows users to request a password reset link by entering their email address.

import SwiftUI

struct ForgotPasswordView: View {
     // MARK: - PROPERTIES
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""

    
     // MARK: - BODY
    var body: some View {
        VStack{
            Image("loginImage")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .padding(.vertical, 32)
            
            VStack(spacing: 12) {
                InputView(text: $email,
                          title: "Email Adress",
                          placeholder: "Enter the email associated with your account")
                .autocapitalization(.none)
                .padding(.horizontal)
                
                Button {
                    Task {
                        await viewModel.forgotPassword(email: email)
                    }//: TASK
                } label: {
                    HStack {
                        Text("Send a Request Link")
                            .fontWeight(.semibold)
                     
                    }//: HSTACK
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    
                } // BUTTON SEND REQUEST LINK
                .background(Color("mainColor").gradient)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        
                        Text("Back to")
                            .foregroundColor(.gray)
                        Text("Sign in")
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }//: HSTACK
                    .font(.system(size: 14))
                }//: BUTTON DISMISS
                
            }//: VSTACK
            
        }//: VSTACK
        .background(backgroundView())
    }
}

extension ForgotPasswordView: AuthenticationFormProtocol {
   var formIsValid: Bool {
       return !email.isEmpty
       && email.contains("@")
     
   }
}//: EXTENSION

 // MARK: - PREVIEW
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(AuthViewModel())
            .preferredColorScheme(.dark)
    }
}
