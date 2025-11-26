import Foundation

enum OliveStatus: String, Codable, CaseIterable {
    case pending
    case completed
}

struct OliveTask: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var status: OliveStatus
    var mood: Mood?

    init(id: UUID = UUID(), title: String, date: Date, status: OliveStatus = .pending, mood: Mood? = nil) {
        self.id = id
        self.title = title
        self.date = date
        self.status = status
        self.mood = mood
    }
}

struct ThemeSettings: Codable {
    var oliveStyle: OliveStyle = .outlined
    var fontSize: Double = 16
    var fontName: String = "System"
    var accentColor: String = "#FF7E2E"
}

enum OliveStyle: String, CaseIterable, Codable {
    case outlined
    case filled
    case pill
}

enum Mood: String, CaseIterable, Codable {
    case calm, happy, focused, energetic, tired, moody

    var colorHex: String {
        switch self {
        case .calm: return "#6EC5E9"
        case .happy: return "#FFCF5C"
        case .focused: return "#8BC34A"
        case .energetic: return "#FF7E2E"
        case .tired: return "#A593E0"
        case .moody: return "#E57373"
        }
    }
}
