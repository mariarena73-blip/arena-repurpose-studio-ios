import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @Environment(\.dismiss) private var dismiss
    @State private var project: Project
    @State private var editedContent: String
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var editedOperationalNotes: String
    @State private var editedContext: RepurposeContext
    @State private var editedCustomContext: String
    @State private var editedAudience: RepurposeAudience
    @State private var editedCustomAudience: String
    @State private var editedVoice: RepurposeVoice
    @State private var editedOutput: RepurposeOutput
    @State private var editedStatus: EditorialStatus
    @State private var isEditing = false
    @State private var showPromptComposer = false
    @State private var showDeleteConfirmation = false
    @State private var copyFeedback: String?
    @State private var selectedQuizOption: String? = nil
    @State private var isFlashcardShowingBack = false
    @State private var generatedStructuredDraft: String?
    @State private var didSaveStructuredDraft = false
    @State private var didCopyStructuredDraft = false

    init(project: Project) {
        _project = State(initialValue: project)
        _editedContent = State(initialValue: project.rawContent)
        _editedTitle = State(initialValue: project.title)
        _editedDescription = State(initialValue: project.description)
        _editedOperationalNotes = State(initialValue: project.operationalNotes)
        _editedContext = State(initialValue: project.repurposeContext)
        _editedCustomContext = State(initialValue: project.customContext)
        _editedAudience = State(initialValue: project.repurposeAudience)
        _editedCustomAudience = State(initialValue: project.customAudience)
        _editedVoice = State(initialValue: project.repurposeVoice)
        _editedOutput = State(initialValue: project.requestedOutput)
        _editedStatus = State(initialValue: project.status)
        _generatedStructuredDraft = State(initialValue: RepurposeTemplateBuilder.draft(for: project))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.lg) {

                // Metadati
                HStack {
                    Label(project.requestedOutput.displayName, systemImage: project.projectType.icon)
                        .font(.system(size: 14))
                        .foregroundColor(.aidTealDigital)
                    if project.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.aidArancioOro)
                            .accessibilityLabel("Preferito")
                    }
                    Spacer()
                    if isEditing {
                        Picker("", selection: $editedStatus) {
                            ForEach(EditorialStatus.allCases, id: \.self) { s in
                                Text(s.rawValue).tag(s)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.aidTurchese)
                    } else {
                        StatusBadge(status: project.status)
                    }
                }

                Divider()

                if !isEditing {
                    RepurposeMetadataView(project: project)
                    Divider()
                }

                if !isEditing {
                    switch project.type {
                    case .quiz:
                        LocalQuizView(project: project, selectedOption: $selectedQuizOption)
                    case .flashcard:
                        LocalFlashcardView(
                            project: project,
                            isShowingBack: $isFlashcardShowingBack
                        )
                    default:
                        EmptyView()
                    }
                }

                if !isEditing, let generatedStructuredDraft {
                    StructuredDraftView(
                        draft: generatedStructuredDraft,
                        didSave: didSaveStructuredDraft,
                        didCopy: didCopyStructuredDraft
                    ) {
                        saveStructuredDraft(generatedStructuredDraft)
                    } onCopy: {
                        copyStructuredDraft(generatedStructuredDraft)
                    }
                }

                // Titolo (in modalità edit)
                if isEditing {
                    editTitleSection
                    editWorkflowSection
                } else {
                    detailCopySection
                    generatedOutputSection
                }

                // Contenuto
                VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
                    Text(AIDVoice.Detail.content)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)

                    if isEditing {
                        TextEditor(text: $editedContent)
                            .font(.system(size: 15))
                            .frame(minHeight: 200)
                            .padding(AIDTheme.Spacing.sm)
                            .background(Color(.systemGray6))
                            .cornerRadius(AIDTheme.Corner.sm)
                    } else {
                        Text(project.rawContent)
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                if isEditing {
                    editNotesSection
                }

                Divider()

                // Date
                HStack {
                    Text(AIDVoice.Detail.createdAt)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text(project.createdAt, style: .date)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                // Handoff alla generazione esterna corrente.
                if !isEditing {
                    Button {
                        showPromptComposer = true
                    } label: {
                        Label(AIDVoice.Detail.composePrompt, systemImage: "wand.and.stars")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(AIDTheme.Spacing.md)
                            .background(Color.aidTealDigital)
                            .foregroundColor(.white)
                            .cornerRadius(AIDTheme.Corner.md)
                    }

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Elimina progetto", systemImage: "trash")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding(AIDTheme.Spacing.md)
                            .background(Color.aidFragola.opacity(0.18))
                            .foregroundColor(.aidFragola)
                            .cornerRadius(AIDTheme.Corner.md)
                    }
                }
            }
            .padding(AIDTheme.Spacing.md)
            .padding(.bottom, AIDTheme.Spacing.xl)
        }
        .navigationTitle(project.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: project.isFavorite ? "star.fill" : "star")
                }
                .foregroundColor(project.isFavorite ? .aidArancioOro : .aidTurchese)
                .accessibilityLabel(project.isFavorite ? "Togli preferito" : "Segna preferito")
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? AIDVoice.Detail.save : AIDVoice.Detail.edit) {
                    if isEditing {
                        saveEdits()
                    }
                    isEditing.toggle()
                }
                .foregroundColor(.aidTurchese)
            }
        }
        .alert("Eliminare il progetto?", isPresented: $showDeleteConfirmation) {
            Button("Annulla", role: .cancel) {}
            Button("Elimina", role: .destructive) {
                deleteProject()
            }
        } message: {
            Text("Il progetto sara' rimosso da Home e Archivio.")
        }
        .sheet(isPresented: $showPromptComposer, onDismiss: refreshProjectFromStorage) {
            NavigationStack {
                PromptComposerView(project: project, showsCloseButton: true)
            }
        }
    }

    private func saveStructuredDraft(_ draft: String) {
        project.rawContent = draft
        project.updatedAt = Date()
        storage.save(project)
        didSaveStructuredDraft = true
    }

    private func copyStructuredDraft(_ draft: String) {
        UIPasteboard.general.string = draft
        didCopyStructuredDraft = true
    }

    private var editTitleSection: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.xs) {
                Text("Titolo")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                TextField("Titolo (opzionale)", text: $editedTitle)
                    .font(.system(size: 16))
                    .padding(AIDTheme.Spacing.sm)
                    .background(Color(.systemGray6))
                    .cornerRadius(AIDTheme.Corner.sm)
            }

            VStack(alignment: .leading, spacing: AIDTheme.Spacing.xs) {
                Text(AIDVoice.Capture.shortDescription)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                TextField(AIDVoice.Capture.shortDescriptionPlaceholder, text: $editedDescription, axis: .vertical)
                    .lineLimit(2...4)
                    .font(.system(size: 16))
                    .padding(AIDTheme.Spacing.sm)
                    .background(Color(.systemGray6))
                    .cornerRadius(AIDTheme.Corner.sm)
            }
        }
    }

    private var editWorkflowSection: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Picker(AIDVoice.Capture.context, selection: $editedContext) {
                ForEach(RepurposeContext.allCases) { context in
                    Text(context.displayName).tag(context)
                }
            }

            if editedContext == .other {
                TextField(AIDVoice.Capture.customContext, text: $editedCustomContext, axis: .vertical)
                    .lineLimit(1...3)
            }

            Picker(AIDVoice.Capture.audience, selection: $editedAudience) {
                ForEach(RepurposeAudience.allCases) { audience in
                    Text(audience.displayName).tag(audience)
                }
            }

            if editedAudience == .other {
                TextField(AIDVoice.Capture.customAudience, text: $editedCustomAudience, axis: .vertical)
                    .lineLimit(1...3)
            }

            Picker(AIDVoice.Capture.voice, selection: $editedVoice) {
                ForEach(RepurposeVoice.allCases) { voice in
                    Text(voice.displayName).tag(voice)
                }
            }

            Picker(AIDVoice.Capture.outputType, selection: $editedOutput) {
                ForEach(RepurposeOutput.allCases) { output in
                    Text(output.displayName).tag(output)
                }
            }
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }

    private var editNotesSection: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
            Text(AIDVoice.Capture.operationalNotes)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            TextEditor(text: $editedOperationalNotes)
                .font(.system(size: 15))
                .frame(minHeight: 120)
                .padding(AIDTheme.Spacing.sm)
                .background(Color(.systemGray6))
                .cornerRadius(AIDTheme.Corner.sm)
        }
    }

    private var detailCopySection: some View {
        CopyActionsView(
            hasGeneratedOutput: generatedOutputText != nil,
            feedback: copyFeedback,
            onCopySource: { copyText(project.rawContent, feedback: "Sorgente copiata") },
            onCopyRequest: { copyText(currentStructuredRequest, feedback: "Richiesta copiata") },
            onCopyOutput: {
                if let generatedOutputText {
                    copyText(generatedOutputText, feedback: "Output copiato")
                }
            }
        )
    }

    @ViewBuilder
    private var generatedOutputSection: some View {
        if let generatedOutputText {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
                Text("Output generato")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.aidTurchese)

                Text(generatedOutputText)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(AIDTheme.Spacing.md)
            .background(Color.aidGrigioScuro.opacity(0.35))
            .cornerRadius(AIDTheme.Corner.md)
        }
    }

    private var currentStructuredRequest: String {
        let customRequest = project.customGenerationRequest?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if let customRequest, !customRequest.isEmpty {
            return customRequest
        }
        return PromptMasterBuilder.prompt(for: project)
    }

    private var generatedOutputText: String? {
        let output = project.generatedOutput?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return output?.isEmpty == true ? nil : output
    }

    private func saveEdits() {
        project.title = editedTitle
        project.description = editedDescription
        project.status = editedStatus
        project.type = editedOutput.projectType
        project.rawContent = editedContent
        if let lastIndex = project.contentItems.indices.last {
            project.contentItems[lastIndex].type = project.type
        }
        project.operationalNotes = editedOperationalNotes
        project.repurposeContext = editedContext
        project.customContext = editedCustomContext
        project.repurposeAudience = editedAudience
        project.customAudience = editedCustomAudience
        project.repurposeVoice = editedVoice
        project.requestedOutput = editedOutput
        project.customGenerationRequest = nil
        project.updatedAt = Date()
        storage.save(project)
        refreshProjectFromStorage()
    }

    private func toggleFavorite() {
        project.isFavorite.toggle()
        storage.save(project)
        refreshProjectFromStorage()
    }

    private func deleteProject() {
        storage.delete(project)
        dismiss()
    }

    private func copyText(_ text: String, feedback: String) {
        UIPasteboard.general.string = text
        copyFeedback = feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copyFeedback = nil
        }
    }

    private func refreshProjectFromStorage() {
        guard let refreshed = storage.projects.first(where: { $0.id == project.id }) else { return }
        project = refreshed
        syncEditedFields(with: refreshed)
        generatedStructuredDraft = RepurposeTemplateBuilder.draft(for: refreshed)
    }

    private func syncEditedFields(with project: Project) {
        editedTitle = project.title
        editedDescription = project.description
        editedContent = project.rawContent
        editedOperationalNotes = project.operationalNotes
        editedContext = project.repurposeContext
        editedCustomContext = project.customContext
        editedAudience = project.repurposeAudience
        editedCustomAudience = project.customAudience
        editedVoice = project.repurposeVoice
        editedOutput = project.requestedOutput
        editedStatus = project.status
    }
}

private struct CopyActionsView: View {
    let hasGeneratedOutput: Bool
    let feedback: String?
    let onCopySource: () -> Void
    let onCopyRequest: () -> Void
    let onCopyOutput: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Text("Azioni locali")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aidTurchese)

            Button(action: onCopySource) {
                Label("Copia sorgente", systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button(action: onCopyRequest) {
                Label("Copia richiesta strutturata", systemImage: "doc.text")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            if hasGeneratedOutput {
                Button(action: onCopyOutput) {
                    Label("Copia output generato", systemImage: "doc.text")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            if let feedback {
                Text(feedback)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.aidTurchese)
            }
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }
}

private struct RepurposeMetadataView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Text(AIDVoice.Detail.workflow)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aidTurchese)

            VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
                metadataRow(label: AIDVoice.Detail.source, value: project.sourceKind.displayName)
                metadataRow(label: AIDVoice.Capture.outputType, value: project.requestedOutput.displayName)
                metadataRow(label: AIDVoice.Capture.context, value: project.contextDisplayName)
                metadataRow(label: AIDVoice.Capture.audience, value: project.audienceDisplayName)
                metadataRow(label: AIDVoice.Capture.voice, value: project.repurposeVoice.displayName)

                let notes = project.operationalNotes.trimmingCharacters(in: .whitespacesAndNewlines)
                if !notes.isEmpty {
                    metadataRow(label: AIDVoice.Detail.notes, value: notes)
                }
            }
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }

    private func metadataRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: AIDTheme.Spacing.sm) {
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
                .frame(width: 96, alignment: .leading)
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct StructuredDraftView: View {
    let draft: String
    let didSave: Bool
    let didCopy: Bool
    let onSave: () -> Void
    let onCopy: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Text(AIDVoice.Detail.structuredDraft)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aidTurchese)

            Text(AIDVoice.Detail.structuredDraftNote)
                .font(.system(size: 13))
                .foregroundColor(.secondary)

            Text(draft)
                .font(.system(.body, design: .monospaced))
                .padding(AIDTheme.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.aidGrigioScuro.opacity(0.45))
                .cornerRadius(AIDTheme.Corner.sm)

            Button(action: onCopy) {
                Label(
                    didCopy ? AIDVoice.Detail.structuredDraftCopied : AIDVoice.Detail.copyStructuredDraft,
                    systemImage: didCopy ? "checkmark.circle.fill" : "doc.on.doc"
                )
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(AIDTheme.Spacing.md)
                .background(didCopy ? Color.aidOttanioMedio : Color.aidOttanioScuro)
                .foregroundColor(.white)
                .cornerRadius(AIDTheme.Corner.md)
            }

            Button(action: onSave) {
                Label(
                    didSave ? AIDVoice.Detail.structuredDraftSaved : AIDVoice.Detail.saveStructuredDraft,
                    systemImage: didSave ? "checkmark.circle.fill" : "square.and.arrow.down"
                )
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(AIDTheme.Spacing.md)
                .background(didSave ? Color.aidOttanioMedio : Color.aidOttanioScuro)
                .foregroundColor(.white)
                .cornerRadius(AIDTheme.Corner.md)
            }
            .disabled(didSave)
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }
}

private struct LocalQuizView: View {
    let project: Project
    @Binding var selectedOption: String?

    private var correctAnswer: String {
        let title = project.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return title.isEmpty ? project.displayTitle : title
    }

    private var options: [String] {
        [correctAnswer, "Elemento secondario", "Non definito"]
    }

    private var feedback: String? {
        guard let selectedOption else { return nil }
        return selectedOption == correctAnswer ? "Risposta corretta" : "Risposta da rivedere"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Text("Quiz interattivo")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aidTurchese)

            Text("Qual è il concetto principale di questa bozza?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)

            VStack(spacing: AIDTheme.Spacing.sm) {
                ForEach(options, id: \.self) { option in
                    Button {
                        selectedOption = option
                    } label: {
                        HStack {
                            Text(option)
                                .font(.system(size: 15, weight: .medium))
                            Spacer()
                            if selectedOption == option {
                                Image(systemName: option == correctAnswer ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            }
                        }
                        .padding(AIDTheme.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(optionBackground(option))
                        .foregroundColor(.primary)
                        .cornerRadius(AIDTheme.Corner.sm)
                    }
                    .buttonStyle(.plain)
                }
            }

            if let feedback {
                Text(feedback)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(selectedOption == correctAnswer ? .aidArancioOro : .aidFragola)
            }
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }

    private func optionBackground(_ option: String) -> Color {
        guard selectedOption == option else {
            return Color.aidGrigioScuro.opacity(0.45)
        }

        return option == correctAnswer
            ? Color.aidArancioOro.opacity(0.28)
            : Color.aidFragola.opacity(0.28)
    }
}

private struct LocalFlashcardView: View {
    let project: Project
    @Binding var isShowingBack: Bool

    private var frontText: String {
        let title = project.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return title.isEmpty ? project.displayTitle : title
    }

    private var backText: String {
        let content = project.rawContent.trimmingCharacters(in: .whitespacesAndNewlines)
        return content.isEmpty ? "Nessun contenuto disponibile." : content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
            Text("Flashcard")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.aidTurchese)

            Button {
                isShowingBack.toggle()
            } label: {
                VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
                    Text(isShowingBack ? "Retro" : "Fronte")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.aidArancioOro)

                    Text(isShowingBack ? backText : frontText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, minHeight: 160, alignment: .center)
                        .multilineTextAlignment(.center)
                }
                .padding(AIDTheme.Spacing.lg)
                .frame(maxWidth: .infinity)
                .background(Color.aidGrigioScuro.opacity(0.45))
                .cornerRadius(AIDTheme.Corner.md)
            }
            .buttonStyle(.plain)

            Button(isShowingBack ? "Mostra fronte" : "Mostra retro") {
                isShowingBack.toggle()
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.aidTurchese)
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.35))
        .cornerRadius(AIDTheme.Corner.md)
    }
}
