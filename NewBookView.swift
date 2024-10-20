//
//  NewBookView.swift
//  MyBooks
//
//  Created by Aldrin Thivyanathan on 20/10/24.
//

import SwiftUI

struct NewBookView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var title: String = ""
    @State private var author: String = ""
   
    var body: some View {
       NavigationStack {
        Form {
            TextField("Title", text: $title)
            TextField("Author", text: $author)
            Button("Create") {
                let newBook = Book(title: title, author: author)
                modelContext.insert(newBook)
                dismiss()
            } 
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(.borderedProminent)
            .disabled(title.isEmpty || author.isEmpty)
            .padding(.vertical)
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
       }
    }
}

#Preview {
    NewBookView()
}
