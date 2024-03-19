//
//  Article.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import Foundation
import CoreLocation

enum ArticleStatus {
    case active
    case archived
    
    var stringValue: String {
        switch self {
        case .active:
            return "ArticleStatusActive"
        case .archived:
            return "ArticleStatusArchived"
        }
    }
}

class Article: Codable {

    // MARK: - Properties

    let creatorId: String
    let articleId: String?
    
    let title: String
    let subtitle: String
    let content: String
    let creationDate: String
    let creatorName: String
    let status: String
    
    // MARK: - Init

    init(creatorId: String,
        articleId: String,
        title: String,
        subtitle: String,
        content: String,
        creationDate: String,
        creatorName: String,
        status: String) {
        
        self.creatorId = creatorId
        self.articleId = articleId
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.creationDate = creationDate
        self.creatorName = creatorName
        self.status = status
    }

    var parsedDate: String {
        get {
            // Formatter for parsing the ISO8601 string
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust if needed

            // Parse the date string
            guard let date = isoFormatter.date(from: creationDate) else {
                return ""
            }

            // Formatter for desired output format
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd.MM.yyyy" // Change format as needed (e.g., "MMM d, yyyy")
            return outputFormatter.string(from: date)
        }
    }
}
