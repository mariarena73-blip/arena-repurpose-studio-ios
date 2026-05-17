import SwiftUI

private struct ContentEntry: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let defaultType: ProjectType
}

private let allEntries: [ContentEntry] = [
    ContentEntry(title: "Idea vocale o testo dettato", description: "Detti o scrivi un'idea grezza. Scegli poi il formato.", icon: "mic.fill", defaultType: .quiz),
    ContentEntry(title: "Post Facebook da adattare", description: "Incolla un post, anche in inglese, da tradurre e rielaborare.", icon: "bubble.left.and.bubble.right.fill", defaultType: .facebookPostAid),
    ContentEntry(title: "Link YouTube o trascrizione", description: "Incolla un link o una trascrizione da trasformare localmente.", icon: "link.circle.fill", defaultType: .youtubeRepurpose),
    ContentEntry(title: "Testo libero", description: "Parti da appunti, note o materiale gia scritto.", icon: "doc.text.fill", defaultType: .text),
    ContentEntry(title: "Quiz", description: "Domande con risposta corretta e distrattori.", icon: "questionmark.circle.fill", defaultType: .quiz),
    ContentEntry(title: "Flashcard", description: "Schede fronte/retro per studio attivo.", icon: "rectangle.stack.fill", defaultType: .flashcard),
    ContentEntry(title: "Script YouTube", description: "Struttura un video didattico dall'inizio alla fine.", icon: "play.rectangle.fill", defaultType: .youtubeScript),
    ContentEntry(title: "Mappa concettuale", description: "Nodi e relazioni tra concetti chiave.", icon: "square.grid.3x3.fill", defaultType: .conceptMap),
    ContentEntry(title: "Infografica", description: "Dati e struttura per visualizzazione grafica.", icon: "chart.bar.fill", defaultType: .infographic),
]

struct NewContentView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @Binding var isSheetPresented: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var captureType: ProjectType = .quiz
    @State private var navigateToCapture = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AIDTheme.Spacing.md) {
                    Text(AIDVoice.NewContent.subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .padding(.top, AIDTheme.Spacing.xs)

                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: AIDTheme.Spacing.sm
                    ) {
                        ForEach(allEntries) { entry in
                            Button {
                                captureType = entry.defaultType
                                navigateToCapture = true
                            } label: {
                                VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
                                    Image(systemName: entry.icon)
                                        .font(.system(size: 22))
                                        .foregroundColor(.aidTurchese)
                                    Text(entry.title)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text(entry.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AIDTheme.Spacing.md)
                                .background(Color.aidGrigioScuro.opacity(0.45))
                                .cornerRadius(AIDTheme.Corner.md)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(AIDTheme.Spacing.md)
            }
            .navigationTitle(AIDVoice.NewContent.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Chiudi") { dismiss() }
                }
            }
            .navigationDestination(isPresented: $navigateToCapture) {
                QuickCaptureView(defaultType: captureType, isSheetPresented: $isSheetPresented)
                    .environmentObject(storage)
            }
        }
    }
}
