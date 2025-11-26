import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var store: OliveStore
    @State private var displayedMonth: Date = Date()

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(monthYearFormatter.string(from: displayedMonth))
                    .font(.headline)
                Spacer()
            }
            dayOfWeekHeader
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                ForEach(generateDays(for: displayedMonth), id: \._self) { day in
                    calendarCell(for: day)
                        .frame(height: 42)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)).shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4))
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -40 { shiftMonth(by: 1) }
                    if value.translation.width > 40 { shiftMonth(by: -1) }
                }
        )
        .onAppear { displayedMonth = store.currentDate }
    }

    private var dayOfWeekHeader: some View {
        HStack {
            ForEach(weekdays, id: \._self) { day in
                Text(day)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func calendarCell(for date: Date?) -> some View {
        Group {
            if let date = date {
                VStack(spacing: 4) {
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.body)
                        .foregroundColor(Calendar.current.isDate(date, inSameDayAs: store.currentDate) ? Color(hex: store.theme.accentColor) : .primary)
                    if let status = store.completionState(for: date) {
                        Circle()
                            .fill(status == .completed ? Color(hex: "#5DB075") : Color(hex: "#FF7E2E"))
                            .frame(width: 8, height: 8)
                    } else {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(6)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Calendar.current.isDate(date, inSameDayAs: store.currentDate) ? Color(hex: store.theme.accentColor).opacity(0.12) : .clear)
                )
                .onTapGesture { store.currentDate = date }
            } else {
                Color.clear
            }
        }
    }

    private func shiftMonth(by value: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: value, to: displayedMonth) else { return }
        displayedMonth = newDate
        if !Calendar.current.isDate(store.currentDate, equalTo: newDate, toGranularity: .month) {
            store.currentDate = newDate
        }
    }

    private func generateDays(for date: Date) -> [Date?] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: monthInterval.start) - calendar.firstWeekday
        let offset = (firstWeekday + 7) % 7

        var days: [Date?] = Array(repeating: nil, count: offset)
        var current = monthInterval.start

        while current < monthInterval.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        return days
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    private var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(OliveStore())
    }
}
