//
//  Page.swift
//  sveska
//
//  Created by Ilija Djurkovic on 3/2/25.
//

import SwiftUI
import SwiftData

@Model
class Page {
    
    var title: String
    @Relationship(deleteRule: .cascade, inverse: \Note.page)
    var notes: [Note]?
    
    init(title: String) {
        self.title = title
    }
}
