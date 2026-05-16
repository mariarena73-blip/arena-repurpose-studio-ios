import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @State private var filterStatus: EditorialStatus? = nil

    private var filtered: [Project] {
        guard let s = filterStatus else { return storage.projects }
        return storage.projects.filter { $0.status == s }
    }

    var body: some View {
        Group {
            if storage.projects.isEmpty {
                VStack(spacing: AIDTheme.Spacing.md) {
                    Image(systemName: "archivebox")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
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
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(
                                top: AIDTheme.Spacing.xs,
                                leading: AIDTheme.Spacing.md,
                                bottom: AIDTheme.Spacing.xs,
                                trailing: AIDTheme.Spacing.md
                            ))
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationTitle(AIDVoice.Archive.title)
        .navigationBarTitleDisplayMode(.large)
    }

    private func deleteItems(at offsets: IndexSet) {
        let ids = offsets.map { filtered[$0].id }
        for id in ids {
            if let p = storage.projects.first(where: { $0.id == id }) {
                storage.delete(p)
            }
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
                .background(isSelected ? Color.aidDeepBlue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}
