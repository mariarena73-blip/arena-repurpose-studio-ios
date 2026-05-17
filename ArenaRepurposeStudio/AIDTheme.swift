import SwiftUI

extension Color {
    static let aidOttanioScuro = Color(red: 46/255, green: 109/255, blue: 116/255)
    static let aidOttanioMedio = Color(red: 0/255, green: 145/255, blue: 147/255)
    static let aidTurchese = Color(red: 0/255, green: 212/255, blue: 210/255)
    static let aidBluScuro = Color(red: 16/255, green: 50/255, blue: 92/255)
    static let aidBluOceano = Color(red: 0/255, green: 84/255, blue: 147/255)
    static let aidArancioOro = Color(red: 255/255, green: 166/255, blue: 2/255)
    static let aidBeige = Color(red: 246/255, green: 239/255, blue: 220/255)
    static let aidGrigioScuro = Color(red: 66/255, green: 66/255, blue: 66/255)
    static let aidGrigioChiaro = Color(red: 146/255, green: 146/255, blue: 146/255)
    static let aidFragola = Color(red: 194/255, green: 89/255, blue: 109/255)

    static let aidDeepBlue = Color.aidBluOceano
    static let aidPurpleBlue = Color.aidOttanioScuro
    static let aidTealDigital = Color.aidTurchese
    static let aidEnergyYellow = Color.aidArancioOro
    static let aidCoral = Color.aidFragola
    static let aidSupportGreen = Color.aidOttanioMedio
}

extension EditorialStatus {
    var uiColor: Color {
        switch self {
        case .draft: return .aidGrigioChiaro
        case .review: return .aidArancioOro
        case .published: return .aidTurchese
        }
    }
}

enum AIDTheme {
    enum Color {
        static let accentFallback      = SwiftUI.Color.aidTurchese
        static let backgroundFallback  = SwiftUI.Color(.systemBackground)
        static let primaryFallback     = SwiftUI.Color.primary
        static let secondaryFallback   = SwiftUI.Color.secondary
        static let primaryGradient = LinearGradient(
            colors: [.aidOttanioScuro, .aidTurchese],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    enum Font {
        static let largeTitle = SwiftUI.Font.system(size: 28, weight: .bold)
        static let title      = SwiftUI.Font.system(size: 22, weight: .semibold)
        static let body       = SwiftUI.Font.system(size: 16)
        static let caption    = SwiftUI.Font.system(size: 13)
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum Corner {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
    }
}
