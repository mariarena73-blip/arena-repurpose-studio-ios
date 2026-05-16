import Foundation

enum ContentType: String, Codable, CaseIterable {
    case text = "Testo"
    case idea = "Idea"
    case voice = "Vocale"
}

struct ContentItem: Identifiable, Codable {
    var id: UUID = UUID()
    var body: String
    var type: ContentType
    var createdAt: Date = Date()
}

struct Project: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var description: String = ""
    var tags: [String] = []
    var contentItems: [ContentItem] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    var lastContent: String? {
        contentItems.last?.body
    }
}
