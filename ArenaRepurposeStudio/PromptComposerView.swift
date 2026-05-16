import SwiftUI

struct PromptComposerView: View {
    var project: Project? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var isCopied = false

    private var prompt: String {
        guard let project else { return "" }
        return """
        Contesto: \(project.projectType.promptContext)

        Materiale di partenza:
        \(project.rawContent)

        Obiettivo: Trasforma il materiale di partenza in \(project.projectType.rawValue.lowercased()).
        Lingua: italiano.
        Struttura: chiara, diretta, orientata all'uso pratico in aula.
        Criteri di qualità: metodo verificabile, adattabile a diversi livelli, senza linguaggio promozionale.
        """
    }

    var body: some View {
        Group {
            if project == nil {
                emptyState
            } else {
                composerContent
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: AIDTheme.Spacing.lg) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 48))
                .foregroundColor(.aidTealDigital)
            Text("Prompt strutturato")
                .font(AIDTheme.Font.title)
            Text("Seleziona un progetto dall'archivio per generare il prompt strutturato.")
                .font(AIDTheme.Font.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AIDTheme.Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(AIDVoice.PromptComposer.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var composerContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.lg) {
                Text(AIDVoice.PromptComposer.intro)
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
                    .background(isCopied ? Color.aidSupportGreen : Color.aidDeepBlue)
                    .foregroundColor(.white)
                    .cornerRadius(AIDTheme.Corner.md)
                }
            }
            .padding(AIDTheme.Spacing.md)
        }
        .navigationTitle(AIDVoice.PromptComposer.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Chiudi") { dismiss() }
            }
        }
    }

    private func copyPrompt() {
        UIPasteboard.general.string = prompt
        isCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isCopied = false
        }
    }
}
