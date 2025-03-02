//
//  Default.swift
//  sveska
//
//  Created by Ilija Djurkovic on 3/2/25.
//

import SwiftUI
import SwiftData

struct Default: View {
    
    @State private var selectedTab: String? = "All"
    @Query(animation: .bouncy(duration: 500)) private var pages: [Page]
    
    @State private var addPage: Bool = false
    @State private var pageTitle: String = ""
    @Environment(\.modelContext) private var context
    
    @State private var requestedPage: Page?
    @State private var deletePage: Bool = false
    @State private var renamePage: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Section("Categories") {
                    Text("All")
                        .tag("All")
                    Text("Recent")
                        .tag("Recent")
                    Text("Favorites")
                        .tag("Favorites")
                    Text("Archive")
                        .tag("Archive")
                }
                
                Section("Pages") {
                    ForEach(pages) { page in
                        Text(page.title)
                            .tag(page.title)
                            .contextMenu {
                                Button("Rename") {
                                    pageTitle = page.title
                                    requestedPage = page
                                    renamePage = true
                                }
                                Button("Delete") {
                                    pageTitle = page.title
                                    requestedPage = page
                                    deletePage = true
                                }
                            }
                    }
                }
            }
            Button {
                addPage.toggle()
            } label: {
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "text.page")
                    Text("New Page")
                }
                .frame(maxWidth: .infinity, minHeight: 25)
            }
            .buttonStyle(.borderedProminent)
            .padding(10)
            .navigationSplitViewColumnWidth(min: 120, ideal: 160, max:250)
        } detail: {
            
        }
        .navigationSplitViewColumnWidth(min: 120, ideal: 160, max:300)
        .navigationTitle(selectedTab ?? "Notes")
        .alert("Add Page", isPresented: $addPage) {
            TextField("Title", text: $pageTitle)
            Button("Cancel", role: .cancel) {
                pageTitle = ""
            }
            Button("Done") {
                let page = Page(title: pageTitle)
                context.insert(page)
                pageTitle = ""
            }
        }
        .alert("Rename Page", isPresented: $renamePage) {
            TextField("Title", text: $pageTitle)
            Button("Cancel", role: .cancel) {
                pageTitle = ""
                requestedPage = nil
            }
            Button("Done") {
                if let requestedPage {
                    requestedPage.title = pageTitle
                    pageTitle = ""
                    self.requestedPage = nil
                }
            }
        }
        .alert("Are you sure you want to delete \"\(pageTitle)\"?", isPresented: $deletePage) {
            Button("No", role: .cancel) {
                pageTitle = ""
                requestedPage = nil
            }
            Button("Yes", role: .destructive) {
                if let requestedPage {
                    context.delete(requestedPage)
                    pageTitle = ""
                    self.requestedPage = nil
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
