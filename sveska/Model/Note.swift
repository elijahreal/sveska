//
//  Note.swift
//  sveska
//
//  Created by Ilija Djurkovic on 3/2/25.
//

import SwiftUI
import SwiftData

@Model
class Note {
    
    var text: String
    var lastModified: Date
    var favorite: Bool = false
    var archived: Bool = false
    var page: Page?
    
    init(text: String, page: Page? = nil) {
        self.text = text
        self.lastModified = Date()
        self.page = page
    }
}
