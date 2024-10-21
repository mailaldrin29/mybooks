//
//  BookList.swift
//  MyBooks
//
//  Created by Aldrin Thivyanathan on 21/10/24.
//

import SwiftUI
import SwiftData

struct BookList: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var books: [Book]
    
    init(sortOrder: SortOrder, filterString: String) {
        let sortDescriptors: [SortDescriptor<Book>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        case .title:
            [SortDescriptor(\Book.title)]
        case .author:
            [SortDescriptor(\Book.author)]
        }
        let predicate = #Predicate<Book> { book in
            book.title.localizedStandardContains(filterString)
            || book.author.localizedStandardContains(filterString)
            || filterString.isEmpty
        }
        _books = Query(filter: predicate ,sort: sortDescriptors)
    }
    
    var body: some View {
        Group {
            if books.isEmpty {
                ContentUnavailableView("Enter your first book", systemImage: "book.fill")
            } else {
                List {
                    ForEach(books) { book in
                        NavigationLink {
                            EditBookView(book: book)
                        } label: {
                            HStack(spacing: 10) {
                                book.icon
                                VStack(alignment: .leading) {
                                    Text(book.title).font(.title3)
                                    Text(book.author).foregroundStyle(.secondary)
                                    if let rating = book.rating {
                                        HStack {
                                            ForEach(0..<rating, id: \.self) { _ in
                                                Image(systemName: "star.fill")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.yellow)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexset in
                        indexset.forEach { index in
                            let book = books[index]
                            modelContext.delete(book)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    return NavigationStack {
        BookList(sortOrder: SortOrder.status, filterString: "")
    }
    .modelContainer(preview.container)
}