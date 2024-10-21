//
//  MyBooksApp.swift
//  MyBooks
//
//  Created by Aldrin Thivyanathan on 20/10/24.
//

import SwiftUI
import SwiftData

@main
struct MyBooksApp: App {
    let container: ModelContainer
    var body: some Scene {
        WindowGroup {
            BookListView()
        }
        .modelContainer(container)
    }

    init() {
        let schema = Schema([Book.self])
        let config = ModelConfiguration("MyBooks", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
//        let configuration = ModelConfiguration(url: URL.applicationDirectory.appending(path: "MyBooks.store"))
//        do {
//            container = try ModelContainer(for: Book.self, configurations: configuration)
//        } catch {
//            fatalError("Could not configure container")
//        }
//        print(URL.applicationDirectory.path)
    }
}
