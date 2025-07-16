import SwiftUI
import CountdownKit

struct ContentView: View {
    @EnvironmentObject var store: CountdownStore
    @State private var showingAdd = false

    var body: some View {
        NavigationView {
            List {
                ForEach(store.items) { item in
                    CountdownRow(item: item)
                }
                .onDelete(perform: store.delete)
            }
            .navigationTitle("Countdowns")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddCountdownView()
                    .environmentObject(store)
            }
        }
    }
}

struct CountdownRow: View {
    let item: CountdownItem
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
            Text(timeRemainingString)
                .font(.body)
        }
        .onReceive(timer) { input in
            now = input
        }
    }

    private var timeRemainingString: String {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: item.date)
        let d = diff.day ?? 0
        let h = diff.hour ?? 0
        let m = diff.minute ?? 0
        let s = diff.second ?? 0
        return String(format: "%dd %02dh %02dm %02ds", d, h, m, s)
    }
}

struct AddCountdownView: View {
    @EnvironmentObject var store: CountdownStore
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var date: Date = Date().addingTimeInterval(3600)

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                DatePicker("Date", selection: $date)
            }
            .navigationTitle("Add Countdown")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        store.add(title: title, date: date)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CountdownStore())
    }
}
