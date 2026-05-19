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
        let project = Project(
            title: "Unità inclusiva",
            description: "Descrizione breve",
            type: RepurposeOutput.teachingMaterialMarkdown.projectType,
            status: .draft,
            tags: ["test"],
            contentItems: [
                ContentItem(body: "Breve testo di prova", type: RepurposeOutput.teachingMaterialMarkdown.projectType)
            ],
            sourceKind: .pastedText,
            sourceText: "Breve testo di prova",
            operationalNotes: "Usare consegne semplici",
            repurposeContext: .school,
            customContext: "",
            repurposeAudience: .bes,
            customAudience: "",
            repurposeVoice: .profArena,
            requestedOutput: .teachingMaterialMarkdown,
            createdAt: Date(timeIntervalSince1970: 1_777_000_000),
            updatedAt: Date(timeIntervalSince1970: 1_777_000_100)
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let data = try encoder.encode(project)
        let decoded = try decoder.decode(Project.self, from: data)

        XCTAssertEqual(decoded.sourceKind, .pastedText)
        XCTAssertEqual(decoded.sourceText, "Breve testo di prova")
        XCTAssertEqual(decoded.operationalNotes, "Usare consegne semplici")
        XCTAssertEqual(decoded.repurposeContext, .school)
        XCTAssertEqual(decoded.repurposeAudience, .bes)
        XCTAssertEqual(decoded.repurposeVoice, .profArena)
        XCTAssertEqual(decoded.requestedOutput, .teachingMaterialMarkdown)
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
        XCTAssertEqual(decoded.repurposeContext, .school)
        XCTAssertEqual(decoded.repurposeAudience, .teachers)
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
}
