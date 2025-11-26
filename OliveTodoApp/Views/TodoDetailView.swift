import SwiftUI

struct TodoDetailView: View {
    @EnvironmentObject private var store: OliveStore
    @State private var date: Date
    @State private var showAdd = false

    init(date: Date) {
        _date = State(initialValue: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(store.tasks(for: date)) { task in
                        HStack(alignment: .center, spacing: 12) {
                            OliveToggle(style: store.theme.oliveStyle, isOn: task.status == .completed) {
                                store.toggleStatus(for: task)
                            }
                            Text(task.title)
                                .font(.system(size: store.theme.fontSize))
                                .foregroundColor(Color(hex: "#333333"))
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                )
                        )
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button("완료") { store.toggleStatus(for: task) }
                                .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) { store.delete(task) } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                    }
                    .transition(.slide)
                }
                .padding(.horizontal, 2)
                FeelingSelectorView(date: date)
                    .environmentObject(store)
            }
        }
        .padding()
        .background(Color.canvasTexture)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAdd = true }) {
                    Label("추가", systemImage: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            NavigationStack {
                AddOliveView(date: date)
                    .environmentObject(store)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -40 { shiftDate(by: 1) }
                    if value.translation.width > 40 { shiftDate(by: -1) }
                }
        )
        .navigationTitle(dateTitle)
        .onChange(of: store.currentDate) { date = $0 }
    }

    private var header: some View {
        HStack {
            Text(dateTitle)
                .font(.title3.bold())
            Spacer()
            Button(action: { shiftDate(by: -1) }) {
                Image(systemName: "chevron.left")
            }
            Button(action: { shiftDate(by: 1) }) {
                Image(systemName: "chevron.right")
            }
        }
    }

    private var dateTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func shiftDate(by value: Int) {
        if let next = Calendar.current.date(byAdding: .day, value: value, to: date) {
            date = next
            store.currentDate = next
        }
    }
}
