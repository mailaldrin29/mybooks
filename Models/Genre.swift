//
//  Genres.swift
//  MyBooks
//
//  Created by Aldrin Thivyanathan on 22/10/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Genre {
    var name: String
    var color: String
    var books: [Book]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    var hexColor: Color {
        Color(hex: self.color) ?? .red
    }
}
