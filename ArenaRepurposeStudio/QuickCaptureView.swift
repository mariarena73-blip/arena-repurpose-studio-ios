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
                        ForEach(ProjectType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.icon).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.aidDeepBlue)
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
        .navigationTitle(selectedType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { editorFocused = true }
    }

    private var saveButtonColor: Color {
        if isSaved { return .aidSupportGreen }
        return content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? Color(.systemGray4)
            : .aidDeepBlue
    }

    private func saveProject() {
        let project = Project(
            title: titleText,
            rawContent: content,
            projectType: selectedType,
            status: .bozza
        )
        storage.save(project)
        isSaved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            isSheetPresented = false
        }
    }
}
