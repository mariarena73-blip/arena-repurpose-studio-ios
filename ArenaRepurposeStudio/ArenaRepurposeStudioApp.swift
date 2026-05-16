import SwiftUI

@main
struct ArenaRepurposeStudioApp: App {
    @StateObject private var storage = ProjectStorageService()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(storage)
                .preferredColorScheme(.dark)
        }
    }
}
