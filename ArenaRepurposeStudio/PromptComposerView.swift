import SwiftUI
import UIKit

struct PromptComposerView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProject: Project?
    @State private var isCopied = false
    @State private var shortcutFeedback: String?
    @State private var shortcutInstallURL: URL?
    private let showsCloseButton: Bool
    private let notaShortcutURL = "shortcuts://run-shortcut?name=Ai%20Nota%20Taker&input=clipboard"
    private let notaInstallURL = "https://www.icloud.com/shortcuts/83a662925948483dbffb2825f1953ea7"

    init(project: Project? = nil, showsCloseButton: Bool = false) {
        _selectedProject = State(initialValue: project)
        self.showsCloseButton = showsCloseButton
    }

    private var prompt: String {
        guard let project = selectedProject else { return "" }
        return """
        RUOLO OPERATIVO DELL'ASSISTENTE
        Agisci come assistente esperto di repurposing didattico, editoriale e operativo. Trasforma il materiale fornito in un output pronto da usare, mantenendo metodo, chiarezza e aderenza alla sorgente.

        TIPO DI SORGENTE
        \(project.sourceKind.displayName)

        CONTENUTO SORGENTE O RIFERIMENTO
        \(project.rawContent)

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

        OUTPUT RICHIESTO
        \(project.requestedOutput.displayName)

        LINGUA DI OUTPUT
        Italiano.

        VINCOLI
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
                        shortcutFeedback = nil
                        shortcutInstallURL = nil
                        isCopied = false
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
                        ForEach(storage.projects) { project in
                            Button {
                                selectedProject = project
                                shortcutFeedback = nil
                                shortcutInstallURL = nil
                                isCopied = false
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

                Text(AIDVoice.PromptComposer.promptToCopy)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

                Text(prompt)
                    .font(.system(.body, design: .monospaced))
                    .padding(AIDTheme.Spacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(AIDTheme.Corner.sm)

                Button(action: copyPrompt) {
                    Label(
                        isCopied ? AIDVoice.PromptComposer.copied : AIDVoice.PromptComposer.copy,
                        systemImage: isCopied ? "checkmark.circle.fill" : "doc.on.doc"
                    )
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(AIDTheme.Spacing.md)
                    .background(isCopied ? Color.aidOttanioMedio : Color.aidOttanioScuro)
                    .foregroundColor(.white)
                    .cornerRadius(AIDTheme.Corner.md)
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

    private func valueOrNone(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Non presente." : value
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
                Label(AIDVoice.PromptComposer.note, systemImage: "note.text")
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
