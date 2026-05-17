import SwiftUI

struct QuickCaptureView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @Binding var isSheetPresented: Bool

    let defaultType: ProjectType

    @State private var titleText: String = ""
    @State private var content: String = ""
    @State private var selectedType: ProjectType
    @State private var isSaved = false
    @FocusState private var editorFocused: Bool

    private let outputTypes: [ProjectType] = [
        .quiz,
        .flashcard,
        .facebookPostAid,
        .blogArticleAid,
        .imagePrompt,
        .presentationOutline,
        .excalidrawDiagram,
        .youtubeRepurpose,
        .youtubeScript,
        .conceptMap,
        .infographic,
        .text
    ]

    init(defaultType: ProjectType, isSheetPresented: Binding<Bool>) {
        self.defaultType = defaultType
        self._isSheetPresented = isSheetPresented
        self._selectedType = State(initialValue: defaultType)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Campo titolo
            TextField(AIDVoice.Capture.titleField, text: $titleText)
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, AIDTheme.Spacing.md)
                .padding(.vertical, AIDTheme.Spacing.sm)
                .background(Color(.systemGray6))

            Divider()

            // Editor testo principale
            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .font(.system(size: 16))
                    .padding(AIDTheme.Spacing.sm)
                    .focused($editorFocused)

                if content.isEmpty {
                    Text(AIDVoice.Capture.placeholder)
                        .font(.system(size: 16))
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, AIDTheme.Spacing.sm + 4)
                        .padding(.vertical, AIDTheme.Spacing.sm + 8)
                        .allowsHitTesting(false)
                }
            }
            .frame(maxHeight: .infinity)

            Divider()

            // Footer: output type + salva
            VStack(spacing: AIDTheme.Spacing.sm) {
                HStack {
                    Text(AIDVoice.Capture.outputType)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Spacer()
                    Picker("", selection: $selectedType) {
                        ForEach(outputTypes, id: \.self) { type in
                            Label(type.displayName, systemImage: type.icon).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.aidTurchese)
                }

                if shouldShowYouTubeNote {
                    Text(AIDVoice.Capture.youtubeTranscriptNote)
                        .font(.system(size: 12))
                        .foregroundColor(.aidArancioOro)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: saveProject) {
                    Text(isSaved ? AIDVoice.Capture.saved : AIDVoice.Capture.saveAsDraft)
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(AIDTheme.Spacing.md)
                        .background(saveButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(AIDTheme.Corner.md)
                }
                .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaved)
            }
            .padding(AIDTheme.Spacing.md)
            .background(Color(.systemBackground))
        }
        .navigationTitle(selectedType.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { editorFocused = true }
    }

    private var shouldShowYouTubeNote: Bool {
        selectedType == .youtubeRepurpose && isOnlyYouTubeLink(content)
    }

    private var saveButtonColor: Color {
        if isSaved { return .aidSupportGreen }
        return content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? Color(.systemGray4)
            : .aidOttanioMedio
    }

    private func saveProject() {
        let project = Project(
            title: titleText,
            description: content,
            type: selectedType,
            status: .draft,
            tags: [],
            contentItems: [ContentItem(body: content, type: selectedType)],
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
}
