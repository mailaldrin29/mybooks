//
//  EditBookView.swift
//  MyBooks
//
//  Created by Aldrin Thivyanathan on 20/10/24.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book: Book
    @State private var status = Status.onShelf
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var rating: Int? = nil
    @State private var summary: String = ""
    @State private var dateAdded: Date = Date.distantPast
    @State private var dateStarted: Date = Date.distantPast
    @State private var dateCompleted: Date = Date.distantPast
    @State private var firstView: Bool = true
    @State private var recommendedBy = ""
    @State private var showGenres = false
    
    var body: some View {
        HStack{
            Text("Status")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr).tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Date Added")
                }
                
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                
                if status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if !firstView {
                    if newValue == .onShelf {
                        dateStarted = Date.distantPast
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .completed {
                        // from completed to inProgress
                        dateCompleted = Date.distantPast
                    } else if newValue == .inProgress && oldValue == .onShelf {
                        // Book has been started
                        dateStarted = Date.now
                    } else if newValue == .completed && oldValue == .onShelf {
                        // Forgot to start book
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                    } else {
                        // completed
                        dateCompleted = Date.now
                    }
                    firstView = false
                }
            }
            Divider()
            LabeledContent {
                RatingsView(maxRating: 5, currentRating: $rating, width: 30)
            } label: {
                Text("Rating")
            }
            LabeledContent {
                TextField("Title", text: $title)
            } label: {
                Text("Title").foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField("Author", text: $author)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField("Recommended By", text: $recommendedBy)
            } label: {
                Text("Recommended By").foregroundStyle(.secondary)
            }
            Divider()
            Text("Summary").foregroundStyle(.secondary)
            TextEditor(text: $summary)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
            if let genres = book.genres {
                ViewThatFits {
                    GenresStackView(genres: genres)
                    ScrollView(.horizontal, showsIndicators: false) {
                        GenresStackView(genres: genres)
                    }
                }
            }
            HStack {
                Button("Genres", systemImage: "bookmark.fill") {
                    showGenres.toggle()
                }
                .sheet(isPresented: $showGenres) {
                    GenresView(book: book)
                }
                NavigationLink {
                    QuotesListView(book: book)
                } label: {
                    let count = book.quotes?.count ?? 0
                    Label("^[\(count) Quotes](inflect: true)", systemImage: "quote.opening")
                }
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {ToolbarItem(placement: .confirmationAction) {
                Button("Update") {
                    book.status = status.rawValue
                    book.rating = rating
                    book.title = title
                    book.author = author
                    book.summary = summary
                    book.dateAdded = dateAdded
                    book.dateStarted = dateStarted
                    book.dateCompleted = dateCompleted
                    book.recommededBy = recommendedBy
                    dismiss()
                }.buttonStyle(.borderedProminent)
            }
            }
        }
        .onAppear {
            status = Status(rawValue: book.status)!
            rating = book.rating
            title = book.title
            author = book.author
            summary = book.summary
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
            recommendedBy = book.recommededBy
        }
    }
    
    var changed: Bool {
        return book.status != status.rawValue
        || book.rating != rating
        || book.title != title
        || book.author != author
        || book.summary != summary
        || book.dateAdded != dateAdded
        || book.dateStarted != dateStarted
        || book.dateCompleted != dateCompleted
        || book.recommededBy != recommendedBy
    }
}


#Preview {
    let preview = Preview(Book.self)
    let book = Book.sampleBooks[4]
    NavigationStack {
        EditBookView(book: book)
            .modelContainer(preview.container)
    }
}
