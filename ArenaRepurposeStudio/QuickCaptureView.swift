import SwiftUI

struct QuickCaptureView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @Binding var isSheetPresented: Bool

    let sourceKind: SourceKind

    @State private var titleText: String = ""
    @State private var sourceText: String = ""
    @State private var descriptionText: String = ""
    @State private var operationalNotes: String = ""
    @State private var selectedContext: RepurposeContext = .school
    @State private var customContext: String = ""
    @State private var selectedAudience: RepurposeAudience = .teachers
    @State private var customAudience: String = ""
    @State private var selectedVoice: RepurposeVoice = .aid
    @State private var selectedOutput: RepurposeOutput = .teachingMaterialMarkdown
    @State private var isSaved = false
    @FocusState private var editorFocused: Bool

    init(sourceKind: SourceKind, isSheetPresented: Binding<Bool>) {
        self.sourceKind = sourceKind
        self._isSheetPresented = isSheetPresented
    }

    var body: some View {
        Form {
            Section {
                TextField(AIDVoice.Capture.titleField, text: $titleText)
                    .font(.system(size: 17, weight: .semibold))

                editor(
                    title: sourceKind.inputTitle,
                    text: $sourceText,
                    placeholder: sourceKind.placeholder,
                    minHeight: 180
                )

                if sourceKind != .pastedText {
                    Text(AIDVoice.Capture.sourceReferenceNote)
                        .font(.system(size: 12))
                        .foregroundColor(.aidArancioOro)
                }
            }

            Section {
                TextField(AIDVoice.Capture.shortDescriptionPlaceholder, text: $descriptionText, axis: .vertical)
                    .lineLimit(2...4)

                editor(
                    title: AIDVoice.Capture.operationalNotes,
                    text: $operationalNotes,
                    placeholder: AIDVoice.Capture.operationalNotesPlaceholder,
                    minHeight: 110
                )
            } header: {
                Text(AIDVoice.Capture.shortDescription)
            }

            Section {
                Picker(AIDVoice.Capture.context, selection: $selectedContext) {
                    ForEach(RepurposeContext.allCases) { context in
                        Text(context.displayName).tag(context)
                    }
                }

                if selectedContext == .other {
                    TextField(AIDVoice.Capture.customContext, text: $customContext, axis: .vertical)
                        .lineLimit(1...3)
                }

                Picker(AIDVoice.Capture.audience, selection: $selectedAudience) {
                    ForEach(RepurposeAudience.allCases) { audience in
                        Text(audience.displayName).tag(audience)
                    }
                }

                if selectedAudience == .other {
                    TextField(AIDVoice.Capture.customAudience, text: $customAudience, axis: .vertical)
                        .lineLimit(1...3)
                }

                Picker(AIDVoice.Capture.voice, selection: $selectedVoice) {
                    ForEach(RepurposeVoice.allCases) { voice in
                        Text(voice.displayName).tag(voice)
                    }
                }

                Picker(AIDVoice.Capture.outputType, selection: $selectedOutput) {
                    ForEach(RepurposeOutput.allCases) { output in
                        Text(output.displayName).tag(output)
                    }
                }
            } header: {
                Text(AIDVoice.Detail.workflow)
            }

            if sourceKind == .youtubeURL && isOnlyYouTubeLink(sourceText) {
                Section {
                    Text(AIDVoice.Capture.youtubeTranscriptNote)
                        .font(.system(size: 12))
                        .foregroundColor(.aidArancioOro)
                }
            }

            Section {
                Button(action: saveProject) {
                    Text(isSaved ? AIDVoice.Capture.saved : AIDVoice.Capture.saveAsDraft)
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                }
                .disabled(!canSave || isSaved)
                .listRowBackground(saveButtonColor)
                .foregroundColor(.white)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
        .navigationTitle(sourceKind.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { editorFocused = true }
    }

    private var canSave: Bool {
        !sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var saveButtonColor: Color {
        if isSaved { return .aidSupportGreen }
        return canSave ? .aidOttanioMedio : Color(.systemGray4)
    }

    private func saveProject() {
        let projectType = selectedOutput.projectType
        let project = Project(
            title: titleText,
            description: descriptionText,
            type: projectType,
            status: .draft,
            tags: [],
            contentItems: [ContentItem(body: sourceText, type: projectType)],
            sourceKind: sourceKind,
            sourceText: sourceText,
            operationalNotes: operationalNotes,
            repurposeContext: selectedContext,
            customContext: customContext,
            repurposeAudience: selectedAudience,
            customAudience: customAudience,
            repurposeVoice: selectedVoice,
            requestedOutput: selectedOutput,
            createdAt: Date(),
            updatedAt: Date()
        )
        storage.save(project)
        isSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            isSheetPresented = false
        }
    }

    private func isOnlyYouTubeLink(_ value: String) -> Bool {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.contains(where: { $0.isWhitespace }) else { return false }
        return trimmed.contains("youtube.com") || trimmed.contains("youtu.be")
    }

    private func editor(
        title: String,
        text: Binding<String>,
        placeholder: String,
        minHeight: CGFloat
    ) -> some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.xs) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            ZStack(alignment: .topLeading) {
                TextEditor(text: text)
                    .font(.system(size: 15))
                    .frame(minHeight: minHeight)
                    .focused($editorFocused)

                if text.wrappedValue.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 15))
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}
