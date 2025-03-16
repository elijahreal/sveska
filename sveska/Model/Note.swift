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
    var favorite: Bool = false
    var archived: Bool = false
    var creationDate: Date
    var page: Page?
    
    init(text: String, page: Page? = nil) {
        self.text = text
        self.creationDate = Date()
        self.page = page
    }
}
