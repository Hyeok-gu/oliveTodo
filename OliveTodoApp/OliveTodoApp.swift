import SwiftUI

@main
struct OliveTodoApp: App {
    @StateObject private var store = OliveStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainDashboardView()
                    .environmentObject(store)
            }
        }
    }
}

final class OliveStore: ObservableObject {
    @Published var tasks: [OliveTask]
    @Published var theme: ThemeSettings
    @Published var currentDate: Date

    init() {
        let today = Date()
        let calendar = Calendar.current
        let sample = [
            OliveTask(title: "iOS 디자인 리서치", date: today, status: .pending),
            OliveTask(title: "API 명세 작성", date: today, status: .completed),
            OliveTask(title: "주간 회고 작성", date: calendar.date(byAdding: .day, value: -1, to: today) ?? today, status: .pending),
            OliveTask(title: "AOS 플로우 정리", date: calendar.date(byAdding: .day, value: 1, to: today) ?? today, status: .pending)
        ]
        self.tasks = sample
        self.theme = ThemeSettings()
        self.currentDate = today
    }

    func addTask(title: String, date: Date) {
        let new = OliveTask(title: title, date: date)
        tasks.append(new)
    }

    func toggleStatus(for task: OliveTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].status = tasks[index].status == .pending ? .completed : .pending
    }

    func delete(_ task: OliveTask) {
        tasks.removeAll { $0.id == task.id }
    }

    func mood(for date: Date) -> Mood? {
        tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.compactMap { $0.mood }.first
    }

    func setMood(_ mood: Mood, for date: Date) {
        for index in tasks.indices where Calendar.current.isDate(tasks[index].date, inSameDayAs: date) {
            tasks[index].mood = mood
        }
    }

    func tasks(for date: Date) -> [OliveTask] {
        tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func completionState(for date: Date) -> OliveStatus? {
        let daily = tasks(for: date)
        guard !daily.isEmpty else { return nil }
        return daily.allSatisfy { $0.status == .completed } ? .completed : .pending
    }
}
