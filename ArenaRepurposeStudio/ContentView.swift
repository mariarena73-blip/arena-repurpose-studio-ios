import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                ArchiveView()
            }
            .tabItem {
                Label("Archivio", systemImage: "archivebox.fill")
            }

            NavigationStack {
                PromptComposerView()
            }
            .tabItem {
                Label("Genera", systemImage: "wand.and.stars")
            }
        }
        .tint(AIDTheme.Color.accentFallback)
    }
}
