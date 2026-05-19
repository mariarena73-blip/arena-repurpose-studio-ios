import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @State private var filterStatus: EditorialStatus? = nil
    @State private var projectPendingDeletion: Project?
    @State private var archiveFeedback: String?

    private var filtered: [Project] {
        let projects = storage.projects.sortedForDisplay
        guard let s = filterStatus else { return projects }
        return projects.filter { $0.status == s }
    }

    var body: some View {
        Group {
            if storage.projects.isEmpty {
                VStack(spacing: AIDTheme.Spacing.md) {
                    Image(systemName: "archivebox")
                        .font(.system(size: 40))
                        .foregroundColor(.aidTurchese)
                    Text(AIDVoice.Archive.empty)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    // Filtro stato
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AIDTheme.Spacing.sm) {
                            FilterChip(
                                label: AIDVoice.Archive.filterAll,
                                isSelected: filterStatus == nil
                            ) { filterStatus = nil }

                            ForEach(EditorialStatus.allCases, id: \.self) { status in
                                FilterChip(
                                    label: status.rawValue,
                                    isSelected: filterStatus == status
                                ) {
                                    filterStatus = filterStatus == status ? nil : status
                                }
                            }
                        }
                        .padding(.horizontal, AIDTheme.Spacing.md)
                        .padding(.vertical, AIDTheme.Spacing.sm)
                    }

                    Divider()

                    List {
                        ForEach(filtered) { project in
                            NavigationLink(destination: ProjectDetailView(project: project)) {
                                ProjectRowView(project: project)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    toggleFavorite(project)
                                } label: {
                                    Label(project.isFavorite ? "Togli preferito" : "Preferito", systemImage: project.isFavorite ? "star.slash" : "star")
                                }
                                .tint(.aidArancioOro)

                                Button {
                                    copySource(project)
                                } label: {
                                    Label("Copia", systemImage: "doc.on.doc")
                                }
                                .tint(.aidOttanioMedio)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    projectPendingDeletion = project
                                } label: {
                                    Label("Elimina", systemImage: "trash")
                                }
                            }
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
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle(AIDVoice.Archive.title)
        .navigationBarTitleDisplayMode(.large)
        .safeAreaInset(edge: .bottom) {
            if let archiveFeedback {
                Text(archiveFeedback)
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.horizontal, AIDTheme.Spacing.md)
                    .padding(.vertical, AIDTheme.Spacing.sm)
                    .background(Color.aidGrigioScuro.opacity(0.9))
                    .foregroundColor(.aidTurchese)
                    .cornerRadius(AIDTheme.Corner.sm)
                    .padding(.bottom, AIDTheme.Spacing.sm)
            }
        }
        .alert("Eliminare il progetto?", isPresented: deleteConfirmationBinding) {
            Button("Annulla", role: .cancel) {
                projectPendingDeletion = nil
            }
            Button("Elimina", role: .destructive) {
                confirmDeletion()
            }
        } message: {
            Text("Il progetto sara' rimosso da Home e Archivio.")
        }
    }

    private var deleteConfirmationBinding: Binding<Bool> {
        Binding(
            get: { projectPendingDeletion != nil },
            set: { if !$0 { projectPendingDeletion = nil } }
        )
    }

    private func toggleFavorite(_ project: Project) {
        var updated = project
        updated.isFavorite.toggle()
        storage.save(updated)
        archiveFeedback = updated.isFavorite ? "Aggiunto ai preferiti" : "Rimosso dai preferiti"
        clearFeedbackLater()
    }

    private func copySource(_ project: Project) {
        UIPasteboard.general.string = project.rawContent
        archiveFeedback = "Sorgente copiata"
        clearFeedbackLater()
    }

    private func confirmDeletion() {
        guard let projectPendingDeletion else { return }
        storage.delete(projectPendingDeletion)
        self.projectPendingDeletion = nil
        archiveFeedback = "Progetto eliminato"
        clearFeedbackLater()
    }

    private func clearFeedbackLater() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            archiveFeedback = nil
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.aidOttanioMedio : Color.aidGrigioScuro.opacity(0.6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}
