import SwiftUI

struct MainDashboardView: View {
    @EnvironmentObject private var store: OliveStore
    @State private var showAdd = false
    @State private var showToday = false
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 16) {
            header
            CalendarView()
                .environmentObject(store)
            Spacer(minLength: 8)
            todayPeek
            NavigationLink(destination: TodoDetailView(date: store.currentDate).environmentObject(store), isActive: $showToday) {
                EmptyView()
            }
        }
        .padding()
        .background(Color.canvasTexture)
        .sheet(isPresented: $showAdd) {
            NavigationStack {
                AddOliveView(date: store.currentDate)
                    .environmentObject(store)
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                ThemeSettingsView()
                    .environmentObject(store)
            }
        }
        .navigationDestination(isPresented: $showToday) {
            TodoDetailView(date: store.currentDate)
                .environmentObject(store)
        }
    }

    private var header: some View {
        HStack {
            Text("Olive")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: store.theme.accentColor))
            Spacer()
            Button(action: { showAdd = true }) {
                Label("올리브 추가", systemImage: "plus.circle")
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .padding(8)
                    .background(Capsule().fill(Color(hex: store.theme.accentColor).opacity(0.15)))
            }
            Button(action: { showSettings = true }) {
                Image(systemName: "person.crop.circle")
                    .font(.title3)
                    .padding(8)
                    .background(Capsule().fill(Color(hex: store.theme.accentColor).opacity(0.15)))
            }
            Button(action: { showToday = true }) {
                Text("Today")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Capsule().fill(Color(hex: store.theme.accentColor)))
                    .foregroundColor(.white)
            }
        }
    }

    private var todayPeek: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("오늘의 올리브")
                    .font(.headline)
                Spacer()
                NavigationLink(destination: TodoDetailView(date: store.currentDate).environmentObject(store)) {
                    Text("더보기")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: store.theme.accentColor))
                }
                .buttonStyle(.plain)
            }
            let todaysTasks = store.tasks(for: store.currentDate)
            if todaysTasks.isEmpty {
                Text("오늘 추가된 올리브가 없어요.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(todaysTasks.prefix(3)) { task in
                    HStack {
                        OliveToggle(style: store.theme.oliveStyle, isOn: task.status == .completed) {
                            store.toggleStatus(for: task)
                        }
                        Text(task.title)
                            .font(.system(size: store.theme.fontSize))
                            .foregroundColor(Color(hex: "#333333"))
                        Spacer()
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                    .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                }
            }
        }
    }
}
