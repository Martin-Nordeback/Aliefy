//
//  ShareSheet.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-25.
//

import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Not used
    }
}
