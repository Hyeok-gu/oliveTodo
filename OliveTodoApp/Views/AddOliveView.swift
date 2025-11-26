import SwiftUI

struct AddOliveView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: OliveStore
    @State private var date: Date
    @State private var title: String = ""

    init(date: Date) {
        _date = State(initialValue: date)
    }

    var body: some View {
        Form {
            Section("날짜") {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            Section("올리브 내용") {
                TextField("할 일을 적어주세요", text: $title)
                Button(action: addTask) {
                    Label("올리브 추가", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .navigationTitle("올리브 작성")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("닫기") { dismiss() }
            }
        }
    }

    private func addTask() {
        store.addTask(title: title, date: date)
        store.currentDate = date
        dismiss()
    }
}
