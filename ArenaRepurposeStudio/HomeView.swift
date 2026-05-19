import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var storage: ProjectStorageService
    @State private var showNewContent = false

    private var recentProjects: [Project] {
        Array(storage.projects.sortedForDisplay.prefix(5))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AIDTheme.Spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: AIDTheme.Spacing.xs) {
                    Text(AIDVoice.App.name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.aidTurchese)
                    Text(AIDVoice.App.tagline)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                .padding(.top, AIDTheme.Spacing.sm)

                // Azione primaria
                Button {
                    showNewContent = true
                } label: {
                    Label(AIDVoice.Home.newContent, systemImage: "plus.circle.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(AIDTheme.Spacing.md)
                        .background(AIDTheme.Color.primaryGradient)
                        .foregroundColor(.white)
                        .cornerRadius(AIDTheme.Corner.md)
                }

                // Progetti recenti
                VStack(alignment: .leading, spacing: AIDTheme.Spacing.sm) {
                    Text(AIDVoice.Home.recentProjects)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.aidTurchese)

                    if recentProjects.isEmpty {
                        Text(AIDVoice.Home.noRecentProjects)
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                            .padding(.vertical, AIDTheme.Spacing.md)
                    } else {
                        ForEach(recentProjects) { project in
                            NavigationLink(destination: ProjectDetailView(project: project)) {
                                ProjectRowView(project: project)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Link archivio
                if !storage.projects.isEmpty {
                    NavigationLink(destination: ArchiveView()) {
                        HStack {
                            Text(AIDVoice.Home.goToArchive)
                                .font(.system(size: 15))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.aidTealDigital)
                    }
                }
            }
            .padding(.horizontal, AIDTheme.Spacing.md)
            .padding(.bottom, AIDTheme.Spacing.xl)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showNewContent) {
            NewContentView(isSheetPresented: $showNewContent)
                .environmentObject(storage)
        }
    }
}

// MARK: - Shared row + badge

struct ProjectRowView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: AIDTheme.Spacing.xs) {
            HStack {
                Text(project.displayTitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Spacer()
                if project.isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.aidArancioOro)
                        .accessibilityLabel("Preferito")
                }
                StatusBadge(status: project.status)
            }
            HStack(spacing: AIDTheme.Spacing.xs) {
                Image(systemName: project.projectType.icon)
                    .font(.system(size: 11))
                Text(project.projectType.displayName)
                    .font(.system(size: 12))
                Text("·")
                Text(project.createdAt, style: .date)
                        .font(.system(size: 12))
            }
            .foregroundColor(.aidTurchese)
        }
        .padding(AIDTheme.Spacing.md)
        .background(Color.aidGrigioScuro.opacity(0.45))
        .cornerRadius(AIDTheme.Corner.sm)
    }
}

extension Array where Element == Project {
    var sortedForDisplay: [Project] {
        sorted { lhs, rhs in
            if lhs.isFavorite != rhs.isFavorite {
                return lhs.isFavorite && !rhs.isFavorite
            }
            return lhs.updatedAt > rhs.updatedAt
        }
    }
}

struct StatusBadge: View {
    let status: EditorialStatus

    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 11, weight: .medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(status.uiColor.opacity(0.18))
            .foregroundColor(status.uiColor)
            .cornerRadius(6)
    }
}
