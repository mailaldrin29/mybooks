//
//  Book.swift
//  MyBooks
//
//  Created by Aldrin Thivyanathan on 20/10/24.
//

import Foundation
import SwiftData
import SwiftUI
@Model
class Book {
    var title: String
    var author: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var summary: String
    var rating: Int?
    var status: Status.RawValue

    init(title: String,
    author: String,
    dateAdded: Date = Date.now,
    dateStarted: Date = Date.distantPast,
    dateCompleted: Date = Date.distantPast,
    summary: String = "",
    rating: Int? = nil,
    status: Status = .onShelf) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.summary = summary
        self.rating = rating
        self.status = status.rawValue
    }

    var icon: Image {
        switch Status(rawValue: status)! {
        case .onShelf: return Image(systemName: "books.vertical.fill")
        case .completed: return Image(systemName: "checkmark.circle.fill")
        case .inProgress: return Image(systemName: "book.fill")
        }
    }
}

enum Status : Int, Codable, Identifiable, CaseIterable {
    case onShelf
    case completed
    case inProgress

    var id: Self {
        return self
    }

    var descr: String {
        switch self {
        case .onShelf: return "On Shelf"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        }
    }
}
