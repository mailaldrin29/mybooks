//
//  Quote.swift
//  MyBooks
//
//  Created by Aldrin Thivyanathan on 21/10/24.
//

import Foundation
import SwiftData

@Model
class Quote {
    var text: String
    var page: String?
    var creationDate = Date.now
    
    var book: Book?
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
}
