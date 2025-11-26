import SwiftUI

struct ThemeSettingsView: View {
    @EnvironmentObject private var store: OliveStore

    var body: some View {
        Form {
            Section("올리브 버튼") {
                Picker("스타일", selection: $store.theme.oliveStyle) {
                    ForEach(OliveStyle.allCases, id: \._self) { style in
                        Text(style.rawValue)
                    }
                }
            }
            Section("텍스트") {
                Stepper(value: $store.theme.fontSize, in: 12...26, step: 1) {
                    Text("폰트 사이즈: \(Int(store.theme.fontSize))")
                }
                TextField("폰트 이름", text: $store.theme.fontName)
            }
            Section("포인트 컬러") {
                ColorPicker("Accent", selection: Binding(get: {
                    Color(hex: store.theme.accentColor)
                }, set: { newValue in
                    store.theme.accentColor = newValue.toHex() ?? store.theme.accentColor
                }))
            }
        }
        .navigationTitle("마이페이지")
    }
}

private extension Color {
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else { return nil }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
}
