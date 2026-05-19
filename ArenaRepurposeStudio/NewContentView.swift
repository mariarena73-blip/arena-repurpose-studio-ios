import SwiftUI

private struct ContentEntry: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let sourceKind: SourceKind
}

private let allEntries: [ContentEntry] = [
    ContentEntry(title: "Testo incollato", description: "Incolla testo, note o appunti da trasformare.", icon: SourceKind.pastedText.icon, sourceKind: .pastedText),
    ContentEntry(title: "PDF", description: "Inserisci solo un riferimento manuale al PDF.", icon: SourceKind.pdfReference.icon, sourceKind: .pdfReference),
    ContentEntry(title: "DOC/DOCX", description: "Inserisci solo un riferimento manuale al documento.", icon: SourceKind.docReference.icon, sourceKind: .docReference),
    ContentEntry(title: "YouTube URL", description: "Incolla URL o riferimento, senza fetch transcript.", icon: SourceKind.youtubeURL.icon, sourceKind: .youtubeURL),
    ContentEntry(title: "Web URL / articolo", description: "Incolla URL o riferimento, senza scraping.", icon: SourceKind.webURL.icon, sourceKind: .webURL),
]

struct NewContentView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @Binding var isSheetPresented: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var selectedSourceKind: SourceKind = .pastedText
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
                                selectedSourceKind = entry.sourceKind
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
                QuickCaptureView(sourceKind: selectedSourceKind, isSheetPresented: $isSheetPresented)
                    .environmentObject(storage)
            }
        }
    }
}
