//
//  NoteView.swift
//  sveska
//
//  Created by Ilija Djurkovic on 3/2/25.
//

import SwiftUI
import SwiftData

struct NoteView: View {
    
    var tab: String?
    var allPages: [Page]
    @Query private var notes: [Note]
    
    init(tab: String?, allPages: [Page]) {
        self.tab = tab
        self.allPages = allPages
        
        let predicate = #Predicate<Note> {
            return $0.page?.title == tab
        }
        let favoritePredicate = #Predicate<Note> {
            return $0.favorite
        }
        let archivePredicate = #Predicate<Note> {
            return $0.archived
        }
        let allPredicate = #Predicate<Note> {
            return !($0.archived)
        }
        
        let final = tab == "All" ? allPredicate : (tab == "Favorites" ? favoritePredicate : (tab == "Archive" ? archivePredicate : predicate))
        
        _notes = Query(filter : final, sort: \Note.creationDate, animation: .snappy)
    }
    
    var body: some View {
        List {
            ForEach(notes) { note in
                NoteEditorView(note: note)
                    .contextMenu {
                        Menu {
                            ForEach(allPages) { page in
                                Button {
                                    note.page = page
                                } label: {
                                    HStack {
                                        Image(systemName: page == note.page ? "checkmark" : "")
                                        Text(page.title)
                                    }
                                }
                            }
                            Button {
                                note.page = nil
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("None")
                                }
                            }
                        } label: {
                            Text("Page")
                        }
                    }
            }
            .padding([.top, .bottom], 8)
            .listRowSeparator(.hidden)
        }
        .transition(.slide)
    }
}

struct NoteEditorView: View {
    
    @Bindable var note: Note
    @State var deleteNote: Bool = false
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 1) {
                Button("", systemImage: note.favorite ? "suit.heart.fill" : "suit.heart") {
                    note.archived = false
                    note.favorite.toggle()
                }
                .buttonStyle(.borderless)
                Button("", systemImage: note.archived ? "trash.fill" : "trash") {
                    note.favorite = false
                    note.page = nil
                    note.archived.toggle()
                }
                .buttonStyle(.borderless)
                Button("", systemImage: "xmark", role: .destructive) {
                    deleteNote.toggle()
                }
                .buttonStyle(.borderless)
            }
            .alert("Are you sure you want to delete the note?", isPresented: $deleteNote) {
                Button("No", role: .cancel) {
                    
                }
                Button("Yes", role: .destructive) {
                    context.delete(note)
                }
            }
            TextEditor(text: $note.text)
                .font(.body)
                .scrollDisabled(true)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 6)
                .overlay(RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.secondary.opacity(0.2))
                    .fill(Color.secondary.opacity(0.03).gradient.shadow(.inner(color: Color(red: 0, green: 0, blue: 0, opacity: 4), radius: 1.5, x: 0, y: 2)))
                    .allowsHitTesting(false))
                .cornerRadius(6)
        }
    }
}

#Preview {
    ContentView()
}
