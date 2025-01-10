//
//  DocumentModel.swift
//  heat_up
//
//  Created by marat orozaliev on 23/12/2024.
//

import Foundation

class AnalysisDocument: Identifiable {
    var documentId: String
    var title: String
    var content: String
    var author: String
    var createdAt: Date

    init(documentId: String, title: String, content: String, author: String, createdAt: Date) {
        self.documentId = documentId
        self.title = title
        self.content = content
        self.author = author
        self.createdAt = createdAt
    }
}
