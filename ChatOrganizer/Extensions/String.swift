//
//  String.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-02.
//

import Foundation
import SwiftUI

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}




