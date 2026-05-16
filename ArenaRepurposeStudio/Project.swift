import Foundation

enum ProjectType: String, Codable, CaseIterable, Identifiable {
    case quiz = "Quiz"
    case flashcard = "Flashcard"
    case youtubeScript = "Script YouTube"
    case conceptMap = "Mappa concettuale"
    case infographic = "Infografica"
    case text = "Testo libero"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .quiz: return "questionmark.circle.fill"
        case .flashcard: return "rectangle.stack.fill"
        case .youtubeScript: return "play.rectangle.fill"
        case .conceptMap: return "square.grid.3x3.fill"
        case .infographic: return "chart.bar.fill"
        case .text: return "doc.text.fill"
        }
    }
}

enum EditorialStatus: String, Codable, CaseIterable, Identifiable {
    case draft = "Bozza"
    case review = "In revisione"
    case published = "Pubblicato"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .draft: return "pencil.circle"
        case .review: return "clock.circle"
        case .published: return "checkmark.circle.fill"
        }
    }
}

extension EditorialStatus {
    var color: String {
        switch self {
        case .draft: return "secondary"
        case .review: return "orange"
        case .published: return "green"
        }
    }
}

struct ContentItem: Identifiable, Codable {
    var id: UUID = UUID()
    var body: String
    var type: ProjectType
    var createdAt: Date = Date()
}

struct Project: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var description: String = ""
    var type: ProjectType = .text
    var status: EditorialStatus = .draft
    var tags: [String] = []
    var contentItems: [ContentItem] = []
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    var lastContent: String? { contentItems.last?.body }
}
