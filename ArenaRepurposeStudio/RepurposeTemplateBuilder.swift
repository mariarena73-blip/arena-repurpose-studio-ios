import Foundation

enum RepurposeTemplateBuilder {
    static func draft(for project: Project) -> String? {
        switch project.type {
        case .facebookPostAid,
             .blogArticleAid,
             .imagePrompt,
             .presentationOutline,
             .excalidrawDiagram,
             .youtubeRepurpose:
            return structuredGenerationRequest(for: project)
        default:
            return nil
        }
    }

    private static func structuredGenerationRequest(for project: Project) -> String {
        """
        RICHIESTA DI GENERAZIONE PER AI NOTA TAKER

        OBIETTIVO
        Produci direttamente l'output finale richiesto. Non trasformare questa richiesta in un prompt generico e non restituire istruzioni astratte: crea il contenuto finale pronto per il lavoro editoriale, didattico o formativo.

        SORGENTE
        Tipo: \(project.sourceKind.displayName)
        Contenuto o riferimento: \(valueOrNone(project.rawContent))

        CONTESTO
        Selezionato: \(project.repurposeContext.displayName)
        Personalizzato: \(valueOrNone(project.customContext))

        DESTINATARI
        Selezionati: \(project.repurposeAudience.displayName)
        Personalizzati: \(valueOrNone(project.customAudience))

        TONO DI VOCE
        \(project.repurposeVoice.displayName): \(project.repurposeVoice.promptInstruction).

        OUTPUT FINALE RICHIESTO
        \(project.requestedOutput.displayName)

        STRUTTURA ATTESA
        \(project.requestedOutput.structureGuide)

        CRITERI DI QUALITA
        \(project.requestedOutput.qualityCriteria)

        NOTE OPERATIVE
        \(valueOrNone(project.operationalNotes))

        VINCOLI
        - Usa solo la sorgente, il riferimento e le note fornite.
        - Non inventare dati mancanti.
        - Se le informazioni sono insufficienti, segnala chiaramente quali dati mancano prima di proporre l'output.
        - Non fare parsing file, fetch URL, transcript YouTube o scraping.
        - Mantieni il risultato coerente con contesto, destinatari, tono e formato finale richiesto.

        FORMATO FINALE
        \(project.requestedOutput.finalFormat)
        """
    }

    private static func valueOrNone(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Non presente." : value
    }
}
