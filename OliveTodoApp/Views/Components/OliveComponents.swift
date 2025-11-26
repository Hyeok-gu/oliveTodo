import SwiftUI

struct OliveToggle: View {
    let style: OliveStyle
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                switch style {
                case .outlined:
                    Circle()
                        .strokeBorder(Color(hex: isOn ? "#5DB075" : "#333333"), lineWidth: 2)
                        .background(Circle().fill(isOn ? Color(hex: "#5DB075").opacity(0.15) : .clear))
                case .filled:
                    Circle()
                        .fill(isOn ? Color(hex: "#5DB075") : Color.white)
                        .overlay(Circle().stroke(Color(hex: "#333333"), lineWidth: 1))
                case .pill:
                    Capsule()
                        .fill(isOn ? Color(hex: "#5DB075") : Color.white)
                        .overlay(Capsule().stroke(Color(hex: "#333333"), lineWidth: 1))
                        .frame(width: 36, height: 22)
                }
            }
            .frame(width: 28, height: 28)
        }
        .buttonStyle(.plain)
    }
}

struct FeelingSelectorView: View {
    @EnvironmentObject private var store: OliveStore
    let date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("오늘의 기분")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                ForEach(Mood.allCases, id: \._self) { mood in
                    Button(action: { store.setMood(mood, for: date) }) {
                        Circle()
                            .fill(Color(hex: mood.colorHex))
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(store.mood(for: date) == mood ? Color(hex: "#333333") : Color.clear, lineWidth: 2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 12)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }

    static var canvasTexture: Color {
        Color(.systemGray6)
            .overlayTexture()
    }

    func overlayTexture() -> Color {
        let base = UIColor(self)
        let pattern = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20)).image { context in
            base.setFill()
            context.fill(CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
            UIColor.black.withAlphaComponent(0.04).setFill()
            for _ in 0..<10 {
                let x = CGFloat.random(in: 0...20)
                let y = CGFloat.random(in: 0...20)
                context.fill(CGRect(x: x, y: y, width: 1.5, height: 1.5))
            }
        }
        return Color(uiColor: UIColor(patternImage: pattern))
    }
}
