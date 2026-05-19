//
//  ArenaRepurposeStudioTests.swift
//  ArenaRepurposeStudioTests
//
//  Created by Ansh Nanda on 3/25/26.
//

import XCTest
@testable import ArenaRepurposeStudio

final class ArenaRepurposeStudioTests: XCTestCase {
    func testProjectRoundTripsNewRepurposeFields() throws {
        let createdAt = Date(timeIntervalSince1970: 1_777_000_000)
        let updatedAt = Date(timeIntervalSince1970: 1_777_000_100)
        let contentItemID = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
        let project = Project(
            title: "Unità inclusiva",
            description: "Descrizione breve",
            type: RepurposeOutput.excalidrawSchema.projectType,
            status: .review,
            tags: ["test", "bes"],
            contentItems: [
                ContentItem(
                    id: contentItemID,
                    body: "Breve testo di prova",
                    type: RepurposeOutput.excalidrawSchema.projectType,
                    createdAt: createdAt
                )
            ],
            sourceKind: .pdfReference,
            sourceText: "Capitolo 2 del PDF su inclusione motoria",
            operationalNotes: "Usare consegne semplici e passaggi numerati",
            repurposeContext: .other,
            customContext: "Laboratorio motorio inclusivo",
            repurposeAudience: .other,
            customAudience: "Docenti di sostegno e studenti BES",
            repurposeVoice: .profArena,
            requestedOutput: .excalidrawSchema,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let data = try encoder.encode(project)
        let decoded = try decoder.decode(Project.self, from: data)

        XCTAssertEqual(decoded.title, "Unità inclusiva")
        XCTAssertEqual(decoded.description, "Descrizione breve")
        XCTAssertEqual(decoded.type, .excalidrawDiagram)
        XCTAssertEqual(decoded.status, .review)
        XCTAssertEqual(decoded.tags, ["test", "bes"])
        XCTAssertEqual(decoded.contentItems.count, 1)
        XCTAssertEqual(decoded.contentItems.first?.id, contentItemID)
        XCTAssertEqual(decoded.contentItems.first?.body, "Breve testo di prova")
        XCTAssertEqual(decoded.sourceKind, .pdfReference)
        XCTAssertEqual(decoded.sourceText, "Capitolo 2 del PDF su inclusione motoria")
        XCTAssertEqual(decoded.operationalNotes, "Usare consegne semplici e passaggi numerati")
        XCTAssertEqual(decoded.repurposeContext, .other)
        XCTAssertEqual(decoded.customContext, "Laboratorio motorio inclusivo")
        XCTAssertEqual(decoded.contextDisplayName, "Laboratorio motorio inclusivo")
        XCTAssertEqual(decoded.repurposeAudience, .other)
        XCTAssertEqual(decoded.customAudience, "Docenti di sostegno e studenti BES")
        XCTAssertEqual(decoded.audienceDisplayName, "Docenti di sostegno e studenti BES")
        XCTAssertEqual(decoded.repurposeVoice, .profArena)
        XCTAssertEqual(decoded.requestedOutput, .excalidrawSchema)
        XCTAssertEqual(decoded.rawContent, "Capitolo 2 del PDF su inclusione motoria")
        XCTAssertEqual(decoded.createdAt, createdAt)
        XCTAssertEqual(decoded.updatedAt, updatedAt)
    }

    func testLegacyProjectJSONDecodesWithRepurposeDefaults() throws {
        let legacyJSON = """
        {
          "id": "11111111-1111-1111-1111-111111111111",
          "title": "Progetto legacy",
          "description": "Descrizione legacy",
          "type": "Testo libero",
          "status": "Bozza",
          "tags": [],
          "contentItems": [
            {
              "id": "22222222-2222-2222-2222-222222222222",
              "body": "Corpo legacy",
              "type": "Testo libero",
              "createdAt": "2026-05-18T10:00:00Z"
            }
          ],
          "createdAt": "2026-05-18T10:00:00Z",
          "updatedAt": "2026-05-18T10:05:00Z"
        }
        """

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decoded = try decoder.decode(Project.self, from: Data(legacyJSON.utf8))

        XCTAssertEqual(decoded.sourceKind, .pastedText)
        XCTAssertEqual(decoded.sourceText, "Corpo legacy")
        XCTAssertEqual(decoded.rawContent, "Corpo legacy")
        XCTAssertEqual(decoded.operationalNotes, "")
        XCTAssertEqual(decoded.repurposeContext, .school)
        XCTAssertEqual(decoded.customContext, "")
        XCTAssertEqual(decoded.repurposeAudience, .teachers)
        XCTAssertEqual(decoded.customAudience, "")
        XCTAssertEqual(decoded.repurposeVoice, .aid)
        XCTAssertEqual(decoded.requestedOutput, .teachingMaterialMarkdown)
    }

    func testRepurposeOutputUsesTemporaryProjectTypeMapping() {
        XCTAssertEqual(RepurposeOutput.blogArticle.projectType, .blogArticleAid)
        XCTAssertEqual(RepurposeOutput.facebookPost.projectType, .facebookPostAid)
        XCTAssertEqual(RepurposeOutput.lessonSummary.projectType, .text)
        XCTAssertEqual(RepurposeOutput.teachingMaterialMarkdown.projectType, .text)
        XCTAssertEqual(RepurposeOutput.conceptMapMarkdown.projectType, .conceptMap)
        XCTAssertEqual(RepurposeOutput.excalidrawSchema.projectType, .excalidrawDiagram)
        XCTAssertEqual(RepurposeOutput.powerpointOutline.projectType, .presentationOutline)
    }

    func testRepurposeOutputCanBeDerivedFromLegacyProjectTypes() {
        XCTAssertEqual(RepurposeOutput(projectType: .blogArticleAid), .blogArticle)
        XCTAssertEqual(RepurposeOutput(projectType: .facebookPostAid), .facebookPost)
        XCTAssertEqual(RepurposeOutput(projectType: .conceptMap), .conceptMapMarkdown)
        XCTAssertEqual(RepurposeOutput(projectType: .excalidrawDiagram), .excalidrawSchema)
        XCTAssertEqual(RepurposeOutput(projectType: .presentationOutline), .powerpointOutline)
        XCTAssertEqual(RepurposeOutput(projectType: .quiz), .teachingMaterialMarkdown)
    }

    func testPromptMasterContainsRequiredRepurposeInstructions() {
        let project = Project(
            title: "Video inclusione",
            description: "Trasformare il materiale in una guida pronta.",
            type: RepurposeOutput.powerpointOutline.projectType,
            status: .draft,
            contentItems: [
                ContentItem(body: "Trascrizione sintetica sulla valutazione motoria inclusiva.", type: .presentationOutline)
            ],
            sourceKind: .youtubeURL,
            sourceText: "https://youtube.example/video-valutazione-inclusiva",
            operationalNotes: "Inserire esempi per BES e verifica finale.",
            repurposeContext: .sportScience,
            customContext: "Modulo scienze motorie",
            repurposeAudience: .examCandidates,
            customAudience: "Corsisti concorso",
            repurposeVoice: .profArena,
            requestedOutput: .powerpointOutline,
            createdAt: Date(timeIntervalSince1970: 1_777_000_000),
            updatedAt: Date(timeIntervalSince1970: 1_777_000_100)
        )

        let prompt = PromptMasterBuilder.prompt(for: project)

        XCTAssertContains(prompt, "RUOLO OPERATIVO DELL'ASSISTENTE")
        XCTAssertContains(prompt, "assistente esperto di repurposing didattico, editoriale e operativo")
        XCTAssertContains(prompt, "TIPO DI SORGENTE")
        XCTAssertContains(prompt, SourceKind.youtubeURL.displayName)
        XCTAssertContains(prompt, "CONTENUTO SORGENTE O RIFERIMENTO")
        XCTAssertContains(prompt, "https://youtube.example/video-valutazione-inclusiva")
        XCTAssertContains(prompt, "DESCRIZIONE BREVE")
        XCTAssertContains(prompt, "Trasformare il materiale in una guida pronta.")
        XCTAssertContains(prompt, "NOTE OPERATIVE")
        XCTAssertContains(prompt, "Inserire esempi per BES e verifica finale.")
        XCTAssertContains(prompt, "CONTESTO SELEZIONATO")
        XCTAssertContains(prompt, RepurposeContext.sportScience.displayName)
        XCTAssertContains(prompt, "EVENTUALE CONTESTO PERSONALIZZATO")
        XCTAssertContains(prompt, "Modulo scienze motorie")
        XCTAssertContains(prompt, "DESTINATARI SELEZIONATI")
        XCTAssertContains(prompt, RepurposeAudience.examCandidates.displayName)
        XCTAssertContains(prompt, "EVENTUALI DESTINATARI PERSONALIZZATI")
        XCTAssertContains(prompt, "Corsisti concorso")
        XCTAssertContains(prompt, "TONO DI VOCE")
        XCTAssertContains(prompt, RepurposeVoice.profArena.displayName)
        XCTAssertContains(prompt, RepurposeVoice.profArena.promptInstruction)
        XCTAssertContains(prompt, "OUTPUT RICHIESTO")
        XCTAssertContains(prompt, RepurposeOutput.powerpointOutline.displayName)
        XCTAssertContains(prompt, "LINGUA DI OUTPUT")
        XCTAssertContains(prompt, "Italiano.")
        XCTAssertContains(prompt, "STRUTTURA ATTESA DELL'OUTPUT")
        XCTAssertContains(prompt, RepurposeOutput.powerpointOutline.structureGuide)
        XCTAssertContains(prompt, "CRITERI DI QUALITA")
        XCTAssertContains(prompt, RepurposeOutput.powerpointOutline.qualityCriteria)
        XCTAssertContains(prompt, "Non inventare dati mancanti.")
        XCTAssertContains(prompt, "Se le informazioni sono insufficienti")
        XCTAssertContains(prompt, "segnala chiaramente quali dati mancano")
        XCTAssertContains(prompt, "FORMATO FINALE RICHIESTO")
        XCTAssertContains(prompt, RepurposeOutput.powerpointOutline.finalFormat)
    }

    private func XCTAssertContains(
        _ string: String,
        _ substring: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            string.contains(substring),
            "Expected prompt to contain: \(substring)",
            file: file,
            line: line
        )
    }
}
