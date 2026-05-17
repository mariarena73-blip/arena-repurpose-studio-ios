import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @State private var project: Project
    @State private var editedContent: String
    @State private var editedTitle: String
    @State private var editedStatus: EditorialStatus
    @State private var isEditing = false
    @State private var showPromptComposer = false
    @State private var selectedQuizOption: String? = nil
    @State private var isFlashcardShowingBack = false
    @State private var generatedStructuredDraft: String?
    @State private var didSaveStructuredDraft = false
    @State private var didCopyStructuredDraft = false

    init(project: Project) {
        _project = State(initialValue: project)
        _editedContent = State(initialValue: project.rawContent)
        _editedTitle = State(initialValue: project.title)
        _editedStatus = State(initialValue: project.status)
        _generatedStructuredDraft = State(initialValue: RepurposeTemplateBuilder.draft(for: project))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.lg) {

                // Metadati
                HStack {
                    Label(project.projectType.displayName, systemImage: project.projectType.icon)
                        .font(.system(size: 14))
                        .foregroundColor(.aidTealDigital)
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

                // Pulsante Componi prompt
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
                }
            }
            .padding(AIDTheme.Spacing.md)
            .padding(.bottom, AIDTheme.Spacing.xl)
        }
        .navigationTitle(project.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? AIDVoice.Detail.save : AIDVoice.Detail.edit) {
                    if isEditing {
                        project.title = editedTitle
                        project.rawContent = editedContent
                        project.status = editedStatus
                        project.updatedAt = Date()
                        storage.save(project)
                    }
                    isEditing.toggle()
                }
                .foregroundColor(.aidTurchese)
            }
        }
        .sheet(isPresented: $showPromptComposer) {
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
