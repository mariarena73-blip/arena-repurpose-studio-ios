import Foundation

enum SourceKind: String, Codable, CaseIterable, Identifiable {
    case pastedText
    case pdfReference
    case docReference
    case youtubeURL
    case webURL

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pastedText: return "Testo incollato"
        case .pdfReference: return "PDF"
        case .docReference: return "DOC/DOCX"
        case .youtubeURL: return "YouTube URL"
        case .webURL: return "Web URL / articolo / blog"
        }
    }

    var icon: String {
        switch self {
        case .pastedText: return "doc.text.fill"
        case .pdfReference: return "doc.richtext.fill"
        case .docReference: return "doc.fill"
        case .youtubeURL: return "play.rectangle.fill"
        case .webURL: return "link.circle.fill"
        }
    }

    var inputTitle: String {
        switch self {
        case .pastedText: return "Testo sorgente"
        case .pdfReference: return "Riferimento PDF"
        case .docReference: return "Riferimento DOC/DOCX"
        case .youtubeURL: return "URL o riferimento YouTube"
        case .webURL: return "URL o riferimento web"
        }
    }

    var placeholder: String {
        switch self {
        case .pastedText:
            return "Incolla qui il testo di partenza..."
        case .pdfReference:
            return "Scrivi titolo, nome file, appunti o passaggi del PDF da usare come riferimento..."
        case .docReference:
            return "Scrivi titolo, nome file, appunti o passaggi del documento da usare come riferimento..."
        case .youtubeURL:
            return "Incolla URL YouTube o descrivi il video/trascrizione disponibile..."
        case .webURL:
            return "Incolla URL web o descrivi articolo/blog da trasformare..."
        }
    }
}

enum RepurposeContext: String, Codable, CaseIterable, Identifiable {
    case socialAID
    case blogAID
    case school
    case sportScience
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .socialAID: return "Social AID"
        case .blogAID: return "Blog AID"
        case .school: return "Scuola"
        case .sportScience: return "Scienze motorie"
        case .other: return "Altro"
        }
    }
}

enum RepurposeAudience: String, Codable, CaseIterable, Identifiable {
    case teachers
    case students
    case bes
    case examCandidates
    case personalTrainer
    case kinesiologist
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .teachers: return "Docenti"
        case .students: return "Studenti"
        case .bes: return "BES"
        case .examCandidates: return "Candidati al concorso"
        case .personalTrainer: return "Personal trainer"
        case .kinesiologist: return "Chinesiologo"
        case .other: return "Altro"
        }
    }
}

enum RepurposeVoice: String, Codable, CaseIterable, Identifiable {
    case aid
    case profArena
    case levelUp

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .aid: return "AID"
        case .profArena: return "Prof Arena"
        case .levelUp: return "LevelUp"
        }
    }

    var promptInstruction: String {
        switch self {
        case .aid:
            return "professionale, concreto, argomentativo, senza enfasi promozionale"
        case .profArena:
            return "didattico, diretto, operativo, con esempi applicabili"
        case .levelUp:
            return "energico, chiaro, motivante ma sempre verificabile"
        }
    }
}

enum RepurposeOutput: String, Codable, CaseIterable, Identifiable {
    case blogArticle
    case facebookPost
    case lessonSummary
    case teachingMaterialMarkdown
    case conceptMapMarkdown
    case excalidrawSchema
    case powerpointOutline

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .blogArticle: return "Articolo blog"
        case .facebookPost: return "Post Facebook"
        case .lessonSummary: return "Riassunto lezione"
        case .teachingMaterialMarkdown: return "Materiale didattico Markdown"
        case .conceptMapMarkdown: return "Mappa concettuale Markdown"
        case .excalidrawSchema: return "Schema Excalidraw"
        case .powerpointOutline: return "Outline presentazione PowerPoint"
        }
    }

    var structureGuide: String {
        switch self {
        case .blogArticle:
            return "titolo, apertura contestuale, sezioni con sottotitoli, esempi applicativi, chiusura operativa"
        case .facebookPost:
            return "post principale, aggancio iniziale, sviluppo argomentativo, commenti operativi, invito all'azione non promozionale"
        case .lessonSummary:
            return "obiettivi, concetti chiave, spiegazione sintetica, esempi, domande di controllo"
        case .teachingMaterialMarkdown:
            return "titolo, obiettivi, prerequisiti, spiegazione, attività, verifica, adattamenti"
        case .conceptMapMarkdown:
            return "nodo centrale, nodi principali, sotto-nodi, relazioni, legenda sintetica"
        case .excalidrawSchema:
            return "nodi, relazioni, frecce, gruppi visivi, note di layout per Excalidraw"
        case .powerpointOutline:
            return "titolo deck, obiettivo, scaletta slide per slide, suggerimenti visuali, chiusura"
        }
    }

    var finalFormat: String {
        switch self {
        case .blogArticle, .facebookPost, .lessonSummary:
            return "testo strutturato con titoli e sezioni leggibili"
        case .teachingMaterialMarkdown, .conceptMapMarkdown:
            return "Markdown"
        case .excalidrawSchema:
            return "schema testuale pronto da ricreare in Excalidraw"
        case .powerpointOutline:
            return "outline slide-by-slide per PowerPoint"
        }
    }

    var qualityCriteria: String {
        "aderenza al materiale fornito, chiarezza, applicabilita, passaggi verificabili, attenzione ai destinatari, nessun dato inventato"
    }

    // Temporary bridge for legacy UI/template compatibility. RepurposeOutput is the primary workflow taxonomy.
    var projectType: ProjectType {
        switch self {
        case .blogArticle: return .blogArticleAid
        case .facebookPost: return .facebookPostAid
        case .lessonSummary, .teachingMaterialMarkdown: return .text
        case .conceptMapMarkdown: return .conceptMap
        case .excalidrawSchema: return .excalidrawDiagram
        case .powerpointOutline: return .presentationOutline
        }
    }

    init(projectType: ProjectType) {
        switch projectType {
        case .blogArticleAid:
            self = .blogArticle
        case .facebookPostAid:
            self = .facebookPost
        case .conceptMap:
            self = .conceptMapMarkdown
        case .excalidrawDiagram:
            self = .excalidrawSchema
        case .presentationOutline:
            self = .powerpointOutline
        default:
            self = .teachingMaterialMarkdown
        }
    }
}

enum ProjectType: String, Codable, CaseIterable, Identifiable {
    case quiz = "Quiz"
    case flashcard = "Flashcard"
    case facebookPostAid = "Post Facebook Aid"
    case blogArticleAid = "Articolo blog Aid"
    case imagePrompt = "Prompt immagine blocca-scroll"
    case presentationOutline = "Schema presentazione"
    case excalidrawDiagram = "Schema Excalidraw"
    case youtubeRepurpose = "YouTube repurpose"
    case youtubeScript = "Script YouTube"
    case conceptMap = "Mappa concettuale"
    case infographic = "Infografica"
    case text = "Testo libero"
    case freeText = "Testo libero input"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .quiz: return "Quiz"
        case .flashcard: return "Flashcard"
        case .facebookPostAid: return "Post Facebook Aid"
        case .blogArticleAid: return "Articolo blog Aid"
        case .imagePrompt: return "Prompt immagine blocca-scroll"
        case .presentationOutline: return "Schema presentazione"
        case .excalidrawDiagram: return "Schema Excalidraw"
        case .youtubeRepurpose: return "Repurpose YouTube"
        case .youtubeScript: return "Script YouTube"
        case .conceptMap: return "Mappa concettuale"
        case .infographic: return "Infografica"
        case .text, .freeText: return "Testo libero"
        }
    }

    var icon: String {
        switch self {
        case .quiz: return "questionmark.circle.fill"
        case .flashcard: return "rectangle.stack.fill"
        case .facebookPostAid: return "bubble.left.and.bubble.right.fill"
        case .blogArticleAid: return "doc.richtext.fill"
        case .imagePrompt: return "photo.on.rectangle.angled"
        case .presentationOutline: return "rectangle.on.rectangle.angled"
        case .excalidrawDiagram: return "scribble.variable"
        case .youtubeRepurpose: return "link.circle.fill"
        case .youtubeScript: return "play.rectangle.fill"
        case .conceptMap: return "square.grid.3x3.fill"
        case .infographic: return "chart.bar.fill"
        case .text, .freeText: return "doc.text.fill"
        }
    }

    var promptContext: String {
        switch self {
        case .quiz: return "Genera domande o quiz dal materiale fornito."
        case .flashcard: return "Genera flashcard dal materiale fornito."
        case .facebookPostAid: return "Trasforma il materiale in un post Facebook Aid con commenti operativi."
        case .blogArticleAid: return "Trasforma il materiale in una struttura di articolo blog Aid."
        case .imagePrompt: return "Trasforma il materiale in un prompt immagine blocca-scroll per ChatGPT Image 2.0."
        case .presentationOutline: return "Trasforma il materiale in una scaletta di presentazione."
        case .excalidrawDiagram: return "Trasforma il materiale in una descrizione testuale di diagramma."
        case .youtubeRepurpose: return "Trasforma un link, una trascrizione o appunti video in una bozza riutilizzabile."
        case .youtubeScript: return "Genera uno script video dal materiale fornito."
        case .conceptMap: return "Genera una mappa concettuale dal materiale fornito."
        case .infographic: return "Genera una struttura infografica dal materiale fornito."
        case .text, .freeText: return "Rielabora il testo fornito."
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
    var sourceKind: SourceKind = .pastedText
    var sourceText: String = ""
    var operationalNotes: String = ""
    var repurposeContext: RepurposeContext = .school
    var customContext: String = ""
    var repurposeAudience: RepurposeAudience = .teachers
    var customAudience: String = ""
    var repurposeVoice: RepurposeVoice = .aid
    var requestedOutput: RepurposeOutput = .teachingMaterialMarkdown
    var isFavorite: Bool = false
    var customGenerationRequest: String?
    var generatedOutput: String?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    var projectType: ProjectType { type }

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        type: ProjectType = .text,
        status: EditorialStatus = .draft,
        tags: [String] = [],
        contentItems: [ContentItem] = [],
        sourceKind: SourceKind = .pastedText,
        sourceText: String = "",
        operationalNotes: String = "",
        repurposeContext: RepurposeContext = .school,
        customContext: String = "",
        repurposeAudience: RepurposeAudience = .teachers,
        customAudience: String = "",
        repurposeVoice: RepurposeVoice = .aid,
        requestedOutput: RepurposeOutput? = nil,
        isFavorite: Bool = false,
        customGenerationRequest: String? = nil,
        generatedOutput: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.status = status
        self.tags = tags
        self.contentItems = contentItems
        self.sourceKind = sourceKind
        self.sourceText = sourceText
        self.operationalNotes = operationalNotes
        self.repurposeContext = repurposeContext
        self.customContext = customContext
        self.repurposeAudience = repurposeAudience
        self.customAudience = customAudience
        self.repurposeVoice = repurposeVoice
        self.requestedOutput = requestedOutput ?? RepurposeOutput(projectType: type)
        self.isFavorite = isFavorite
        self.customGenerationRequest = customGenerationRequest
        self.generatedOutput = generatedOutput
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var displayTitle: String {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTitle.isEmpty { return trimmedTitle }

        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedDescription.isEmpty {
            return String(trimmedDescription.prefix(40))
        }

        return "Senza titolo"
    }

    var rawContent: String {
        get {
            let trimmedSourceText = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedSourceText.isEmpty { return trimmedSourceText }

            if let lastContent {
                let trimmedLastContent = lastContent.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedLastContent.isEmpty { return trimmedLastContent }
            }

            let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedDescription.isEmpty { return trimmedDescription }

            return ""
        }
        set {
            sourceText = newValue
            if let lastIndex = contentItems.indices.last {
                contentItems[lastIndex].body = newValue
            } else {
                contentItems.append(ContentItem(body: newValue, type: type))
            }
        }
    }

    var lastContent: String? { contentItems.last?.body }

    var contextDisplayName: String {
        repurposeContext == .other && !customContext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? customContext
            : repurposeContext.displayName
    }

    var audienceDisplayName: String {
        repurposeAudience == .other && !customAudience.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? customAudience
            : repurposeAudience.displayName
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case type
        case status
        case tags
        case contentItems
        case sourceKind
        case sourceText
        case operationalNotes
        case repurposeContext
        case customContext
        case repurposeAudience
        case customAudience
        case repurposeVoice
        case requestedOutput
        case isFavorite
        case customGenerationRequest
        case generatedOutput
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        type = try container.decodeIfPresent(ProjectType.self, forKey: .type) ?? .text
        status = try container.decodeIfPresent(EditorialStatus.self, forKey: .status) ?? .draft
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        contentItems = try container.decodeIfPresent([ContentItem].self, forKey: .contentItems) ?? []
        sourceKind = try container.decodeIfPresent(SourceKind.self, forKey: .sourceKind) ?? .pastedText

        let decodedSourceText = try container.decodeIfPresent(String.self, forKey: .sourceText) ?? ""
        sourceText = Project.legacySourceText(
            decodedSourceText: decodedSourceText,
            contentItems: contentItems,
            description: description
        )

        operationalNotes = try container.decodeIfPresent(String.self, forKey: .operationalNotes) ?? ""
        repurposeContext = try container.decodeIfPresent(RepurposeContext.self, forKey: .repurposeContext) ?? .school
        customContext = try container.decodeIfPresent(String.self, forKey: .customContext) ?? ""
        repurposeAudience = try container.decodeIfPresent(RepurposeAudience.self, forKey: .repurposeAudience) ?? .teachers
        customAudience = try container.decodeIfPresent(String.self, forKey: .customAudience) ?? ""
        repurposeVoice = try container.decodeIfPresent(RepurposeVoice.self, forKey: .repurposeVoice) ?? .aid
        requestedOutput = try container.decodeIfPresent(RepurposeOutput.self, forKey: .requestedOutput) ?? RepurposeOutput(projectType: type)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        customGenerationRequest = try container.decodeIfPresent(String.self, forKey: .customGenerationRequest)
        generatedOutput = try container.decodeIfPresent(String.self, forKey: .generatedOutput)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? createdAt
    }

    private static func legacySourceText(
        decodedSourceText: String,
        contentItems: [ContentItem],
        description: String
    ) -> String {
        let trimmedSourceText = decodedSourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedSourceText.isEmpty { return decodedSourceText }

        if let lastBody = contentItems.last?.body {
            let trimmedLastBody = lastBody.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedLastBody.isEmpty { return lastBody }
        }

        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedDescription.isEmpty ? "" : description
    }
}
