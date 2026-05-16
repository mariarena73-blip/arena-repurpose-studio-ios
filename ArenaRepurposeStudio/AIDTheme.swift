import SwiftUI

extension Color {
    static let aidDeepBlue    = Color(red: 16/255,  green: 3/255,   blue: 124/255)
    static let aidPurpleBlue  = Color(red: 46/255,  green: 13/255,  blue: 116/255)
    static let aidTealDigital = Color(red: 0/255,   green: 145/255, blue: 147/255)
    static let aidEnergyYellow = Color(red: 255/255, green: 166/255, blue: 2/255)
    static let aidCoral       = Color(red: 219/255, green: 101/255, blue: 82/255)
    static let aidSupportGreen = Color(red: 149/255, green: 203/255, blue: 164/255)
}

extension EditorialStatus {
    var color: Color {
        switch self {
        case .bozza:        return .aidEnergyYellow
        case .daRivedere:   return .aidCoral
        case .daPubblicare: return .aidTealDigital
        case .pubblicato:   return .aidSupportGreen
        case .archiviato:   return Color(.systemGray)
        }
    }
}

enum AIDTheme {
    enum Color {
        static let accentFallback      = SwiftUI.Color.aidDeepBlue
        static let backgroundFallback  = SwiftUI.Color(.systemBackground)
        static let primaryFallback     = SwiftUI.Color.primary
        static let secondaryFallback   = SwiftUI.Color.secondary
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
