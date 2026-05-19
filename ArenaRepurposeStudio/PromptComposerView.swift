import SwiftUI
import UIKit

enum PromptMasterBuilder {
    static func prompt(for project: Project) -> String {
        """
        RICHIESTA STRUTTURATA PER AI NOTA TAKER

        OBIETTIVO DI GENERAZIONE
        Produci direttamente l'output finale richiesto. Non restituire un nuovo prompt, una bozza di prompt o istruzioni generiche: usa questa richiesta come brief operativo per creare il contenuto finale.

        RUOLO OPERATIVO DELL'ASSISTENTE
        Agisci come assistente esperto di repurposing didattico, editoriale e operativo. Trasforma il materiale fornito in un output pronto da usare, mantenendo metodo, chiarezza e aderenza alla sorgente.

        TIPO DI SORGENTE
        \(project.sourceKind.displayName)

        CONTENUTO SORGENTE O RIFERIMENTO
        \(valueOrNone(project.rawContent))

        DESCRIZIONE BREVE
        \(valueOrNone(project.description))

        NOTE OPERATIVE
        \(valueOrNone(project.operationalNotes))

        CONTESTO SELEZIONATO
        \(project.repurposeContext.displayName)

        EVENTUALE CONTESTO PERSONALIZZATO
        \(valueOrNone(project.customContext))

        DESTINATARI SELEZIONATI
        \(project.repurposeAudience.displayName)

        EVENTUALI DESTINATARI PERSONALIZZATI
        \(valueOrNone(project.customAudience))

        TONO DI VOCE
        \(project.repurposeVoice.displayName): \(project.repurposeVoice.promptInstruction).

        OUTPUT FINALE RICHIESTO
        \(project.requestedOutput.displayName)

        LINGUA DI OUTPUT
        Italiano.

        VINCOLI
        - Produci l'output finale richiesto, non un prompt generico.
        - Non inventare dati mancanti.
        - Se le informazioni sono insufficienti, segnala chiaramente quali dati mancano prima di proporre l'output.
        - Non fare parsing file, fetch URL, transcript YouTube o scraping: usa solo il contenuto o riferimento fornito.
        - Mantieni il risultato coerente con contesto, destinatari e tono selezionati.

        STRUTTURA ATTESA DELL'OUTPUT
        \(project.requestedOutput.structureGuide)

        CRITERI DI QUALITA
        \(project.requestedOutput.qualityCriteria)

        FORMATO FINALE RICHIESTO
        \(project.requestedOutput.finalFormat)
        """
    }

    private static func valueOrNone(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Non presente." : value
    }
}

struct PromptComposerView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProject: Project?
    @State private var isCopied = false
    @State private var generatedGenerationRequest: String
    @State private var currentGenerationRequest: String
    @State private var isEditingRequest = false
    @State private var requestFeedback: String?
    @State private var shortcutFeedback: String?
    @State private var shortcutInstallURL: URL?
    @State private var openRouterAPIKey = ""
    @State private var isGeneratingOpenRouterOutput = false
    @State private var openRouterOutput: String?
    @State private var openRouterModelUsed: String?
    @State private var openRouterErrorMessage: String?
    private let showsCloseButton: Bool
    private let openRouterService = OpenRouterService()
    private let notaShortcutURL = "shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard"
    private let notaInstallURL = "https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7"

    init(project: Project? = nil, showsCloseButton: Bool = false) {
        let generatedRequest = project.map { PromptMasterBuilder.prompt(for: $0) } ?? ""
        let currentRequest = PromptComposerView.initialRequest(
            for: project,
            generatedRequest: generatedRequest
        )
        _selectedProject = State(initialValue: project)
        _generatedGenerationRequest = State(initialValue: generatedRequest)
        _currentGenerationRequest = State(initialValue: currentRequest)
        _openRouterOutput = State(initialValue: PromptComposerView.initialGeneratedOutput(for: project))
        self.showsCloseButton = showsCloseButton
    }

    private var prompt: String {
        currentGenerationRequest
    }

    var body: some View {
        Group {
            if selectedProject == nil {
                projectPicker
            } else {
                composerContent
            }
        }
        .toolbar {
            if selectedProject != nil && showsCloseButton {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AIDVoice.PromptComposer.close) { dismiss() }
                }
            }
            if selectedProject != nil && !showsCloseButton {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AIDVoice.PromptComposer.chooseProject) {
                        selectedProject = nil
                        resetGeneratedState()
                        resetRequestState()
                    }
                }
            }
        }
    }

    private var projectPicker: some View {
        Group {
            if storage.projects.isEmpty {
                VStack(spacing: AIDTheme.Spacing.lg) {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 48))
                        .foregroundColor(.aidTealDigital)
                    pickerIntro
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    Section {
                        pickerIntro
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }

                    Section(AIDVoice.PromptComposer.chooseProject) {
                        ForEach(storage.projects.sortedForDisplay) { project in
                            Button {
                                configureSelectedProject(project)
                            } label: {
                                ProjectRowView(project: project)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(
                                top: AIDTheme.Spacing.xs,
                                leading: AIDTheme.Spacing.md,
                                bottom: AIDTheme.Spacing.xs,
                                trailing: AIDTheme.Spacing.md
                            ))
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(AIDVoice.PromptComposer.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var pickerIntro: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
            Text(AIDVoice.PromptComposer.title)
                .font(AIDTheme.Font.title)
                .foregroundColor(.aidTurchese)
            Text(AIDVoice.PromptComposer.projectPickerGuide)
                .font(AIDTheme.Font.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AIDTheme.Spacing.md)
    }

    private var composerContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.lg) {
                shortcutSection
                openRouterSection

                editableRequestSection

                Button(action: copyPrompt) {
                    Label(
                        isCopied ? AIDVoice.PromptComposer.copied : AIDVoice.PromptComposer.copy,
                        systemImage: isCopied ? "checkmark.circle.fill" : "doc.on.doc"
                    )
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(AIDTheme.Spacing.md)
                    .background(Color.aidGrigioScuro.opacity(0.45))
                    .foregroundColor(isCopied ? .aidSupportGreen : .aidTurchese)
                    .cornerRadius(AIDTheme.Corner.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: AIDTheme.Corner.md)
                            .stroke(isCopied ? Color.aidSupportGreen : Color.aidTurchese.opacity(0.6), lineWidth: 1)
                    )
                }
            }
            .padding(AIDTheme.Spacing.md)
        }
        .navigationTitle(AIDVoice.PromptComposer.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func copyPrompt() {
        UIPasteboard.general.string = prompt
        isCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isCopied = false
        }
    }

    private func resetGeneratedState() {
        shortcutFeedback = nil
        shortcutInstallURL = nil
        isCopied = false
        isGeneratingOpenRouterOutput = false
        openRouterOutput = nil
        openRouterModelUsed = nil
        openRouterErrorMessage = nil
    }

    private func resetRequestState() {
        generatedGenerationRequest = ""
        currentGenerationRequest = ""
        isEditingRequest = false
        requestFeedback = nil
    }

    private func configureSelectedProject(_ project: Project) {
        let generatedRequest = PromptMasterBuilder.prompt(for: project)
        selectedProject = project
        generatedGenerationRequest = generatedRequest
        currentGenerationRequest = Self.initialRequest(
            for: project,
            generatedRequest: generatedRequest
        )
        resetGeneratedState()
        openRouterOutput = Self.initialGeneratedOutput(for: project)
        requestFeedback = nil
        isEditingRequest = false
    }

    private static func initialRequest(
        for project: Project?,
        generatedRequest: String
    ) -> String {
        let customRequest = project?.customGenerationRequest?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let customRequest, !customRequest.isEmpty else {
            return generatedRequest
        }
        return customRequest
    }

    private static func initialGeneratedOutput(for project: Project?) -> String? {
        let output = project?.generatedOutput?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return output?.isEmpty == true ? nil : output
    }

    private var editableRequestSection: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AIDTheme.Spacing.xs) {
                    Text(AIDVoice.PromptComposer.promptToCopy)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.aidTurchese)

                    Text(AIDVoice.PromptComposer.technicalViewNote)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Toggle("Modifica richiesta", isOn: $isEditingRequest)
                    .font(.system(size: 13, weight: .medium))
                    .toggleStyle(.switch)
                    .accessibilityLabel("Modifica richiesta")
            }

            if isEditingRequest {
                TextEditor(text: $currentGenerationRequest)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 320)
                    .padding(AIDTheme.Spacing.sm)
                    .background(Color(.systemGray6))
                    .cornerRadius(AIDTheme.Corner.sm)
            } else {
                Text(prompt)
                    .font(.system(.body, design: .monospaced))
                    .padding(AIDTheme.Spacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(AIDTheme.Corner.sm)
            }

            HStack(spacing: AIDTheme.Spacing.sm) {
                Button {
                    restoreGeneratedRequest()
                } label: {
                    Label("Ripristina richiesta generata", systemImage: "arrow.counterclockwise")
                        .font(.system(size: 13, weight: .semibold))
                }
                .buttonStyle(.bordered)

                Button {
                    saveCurrentRequest()
                } label: {
                    Label("Salva richiesta corrente", systemImage: "square.and.arrow.down")
                        .font(.system(size: 13, weight: .semibold))
                }
                .buttonStyle(.bordered)
            }

            if let requestFeedback {
                Text(requestFeedback)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.aidTurchese)
            }
        }
    }

    private func restoreGeneratedRequest() {
        currentGenerationRequest = generatedGenerationRequest
        if var project = selectedProject {
            project.customGenerationRequest = nil
            selectedProject = project
            storage.save(project)
        }
        requestFeedback = "Richiesta generata ripristinata"
        clearRequestFeedbackLater()
    }

    private func saveCurrentRequest() {
        guard var project = selectedProject else { return }
        let trimmedCurrent = currentGenerationRequest.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedGenerated = generatedGenerationRequest.trimmingCharacters(in: .whitespacesAndNewlines)
        project.customGenerationRequest = trimmedCurrent == trimmedGenerated ? nil : currentGenerationRequest
        selectedProject = project
        storage.save(project)
        requestFeedback = "Richiesta corrente salvata"
        clearRequestFeedbackLater()
    }

    private func clearRequestFeedbackLater() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            requestFeedback = nil
        }
    }

    private var openRouterSection: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Text("OpenRouter sperimentale")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aidTurchese)

            Text("Genera direttamente in app l'output finale usando la richiesta strutturata. Ai Nota Taker resta disponibile come bridge esterno.")
                .font(.system(size: 13))
                .foregroundColor(.secondary)

            SecureField("API key OpenRouter", text: $openRouterAPIKey)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .textContentType(.password)
                .font(.system(size: 15))
                .padding(AIDTheme.Spacing.md)
                .background(Color(.systemGray6))
                .cornerRadius(AIDTheme.Corner.sm)

            Button {
                Task {
                    await generateOutputWithOpenRouter()
                }
            } label: {
                Label("Genera output con OpenRouter", systemImage: "sparkles")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(AIDTheme.Spacing.md)
                    .background(Color.aidOttanioMedio)
                    .foregroundColor(.white)
                    .cornerRadius(AIDTheme.Corner.md)
            }
            .disabled(isGeneratingOpenRouterOutput)
            .opacity(isGeneratingOpenRouterOutput ? 0.75 : 1)

            if isGeneratingOpenRouterOutput {
                HStack(spacing: AIDTheme.Spacing.sm) {
                    ProgressView()
                        .tint(.aidTurchese)
                    Text("Generazione in corso...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }

            if let openRouterErrorMessage {
                Text(openRouterErrorMessage)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.aidFragola)
            }

            if let openRouterModelUsed {
                Text("Modello usato: \(openRouterModelUsed)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.aidArancioOro)
            }

            if let openRouterOutput {
                VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
                    Text("Output generato")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.aidTurchese)

                    Text(openRouterOutput)
                        .font(.system(size: 15))
                        .padding(AIDTheme.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(AIDTheme.Corner.sm)
                }
            }
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }

    @MainActor
    private func generateOutputWithOpenRouter() async {
        let trimmedAPIKey = openRouterAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAPIKey.isEmpty else {
            openRouterErrorMessage = "Inserisci una API key OpenRouter."
            return
        }

        isGeneratingOpenRouterOutput = true
        openRouterOutput = nil
        openRouterModelUsed = nil
        openRouterErrorMessage = nil

        defer {
            isGeneratingOpenRouterOutput = false
        }

        do {
            let result = try await openRouterService.generateOutput(
                for: prompt,
                apiKey: trimmedAPIKey
            )
            openRouterOutput = result.content
            openRouterModelUsed = result.model
            persistGeneratedOutput(result.content)
        } catch let error as LocalizedError {
            openRouterErrorMessage = error.errorDescription ?? "Errore OpenRouter non previsto."
        } catch {
            openRouterErrorMessage = "Errore OpenRouter non previsto."
        }
    }

    private func persistGeneratedOutput(_ output: String) {
        guard var project = selectedProject else { return }
        project.generatedOutput = output
        let trimmedCurrent = currentGenerationRequest.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedGenerated = generatedGenerationRequest.trimmingCharacters(in: .whitespacesAndNewlines)
        project.customGenerationRequest = trimmedCurrent == trimmedGenerated ? nil : currentGenerationRequest
        selectedProject = project
        storage.save(project)
    }

    private var shortcutSection: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Text(AIDVoice.PromptComposer.shortcutSection)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aidTurchese)

            Text(AIDVoice.PromptComposer.shortcutNote)
                .font(.system(size: 13))
                .foregroundColor(.secondary)

            Button {
                runShortcut(
                    urlString: notaShortcutURL,
                    installURLString: notaInstallURL
                )
            } label: {
                Label(AIDVoice.PromptComposer.note, systemImage: "wand.and.stars")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(AIDTheme.Spacing.md)
                    .background(Color.aidArancioOro)
                    .foregroundColor(.black)
                    .cornerRadius(AIDTheme.Corner.md)
            }

            if let shortcutFeedback {
                Text(shortcutFeedback)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.aidArancioOro)
            }

            if let shortcutInstallURL {
                Button {
                    UIApplication.shared.open(shortcutInstallURL)
                } label: {
                    Label(AIDVoice.PromptComposer.installShortcut, systemImage: "arrow.down.circle")
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(AIDTheme.Spacing.md)
                        .background(Color.aidOttanioMedio)
                        .foregroundColor(.white)
                        .cornerRadius(AIDTheme.Corner.md)
                }
            }
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }

    private func runShortcut(urlString: String, installURLString: String) {
        UIPasteboard.general.string = prompt
        shortcutFeedback = nil
        shortcutInstallURL = nil
        let installURL = URL(string: installURLString)

        guard let url = URL(string: urlString) else {
            shortcutFeedback = AIDVoice.PromptComposer.shortcutUnavailableMessage
            shortcutInstallURL = installURL
            return
        }

        UIApplication.shared.open(url) { success in
            if !success {
                shortcutFeedback = AIDVoice.PromptComposer.shortcutUnavailableMessage
                shortcutInstallURL = installURL
            }
        }
    }
}
