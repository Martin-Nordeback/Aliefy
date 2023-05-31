//
//  SectionView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-24.
//
 // MARK: - OVERVIEW
///``Displays a section title and description. It is used in the "AboutView" ``

import SwiftUI

struct SectionView: View {
     // MARK: - PROPERTIES
    
    let title: String
    let description: String
    
     // MARK: - BODY
    var body: some View {
        
        Text(title)
              .fontWeight(.bold)
              .padding(.bottom, 4)
              .padding(.top, 12)
              .foregroundColor(.accentColor)

          Text(description)
              .fontWeight(.thin)
      }
  }

 // MARK: - PREVIEW
struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(title: "Organize Your Chats Effortlessly", description: "Welcome to Aliefy! Keep your conversations tidy and easily accessible by saving them in customized folders. Never lose track of an important chat again!")
            .preferredColorScheme(.dark)
    }
}
