import SwiftUI

struct ProjectDetailView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @State private var project: Project
    @State private var editedContent: String
    @State private var editedTitle: String
    @State private var editedStatus: EditorialStatus
    @State private var isEditing = false
    @State private var showPromptComposer = false

    init(project: Project) {
        _project = State(initialValue: project)
        _editedContent = State(initialValue: project.rawContent)
        _editedTitle = State(initialValue: project.title)
        _editedStatus = State(initialValue: project.status)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.lg) {

                // Metadati
                HStack {
                    Label(project.projectType.rawValue, systemImage: project.projectType.icon)
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
                        .tint(.aidDeepBlue)
                    } else {
                        StatusBadge(status: project.status)
                    }
                }

                Divider()

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
                .foregroundColor(.aidDeepBlue)
            }
        }
        .sheet(isPresented: $showPromptComposer) {
            PromptComposerView(project: project)
        }
    }
}
