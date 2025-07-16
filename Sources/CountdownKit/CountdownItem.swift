import Foundation

struct CountdownItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date

    init(id: UUID = UUID(), title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
}

class CountdownStore: ObservableObject {
    @Published var items: [CountdownItem] = [] {
        didSet { save() }
    }

    private let storageURL: URL = {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.countdown")
        return container?.appendingPathComponent("countdowns.json") ?? FileManager.default.temporaryDirectory.appendingPathComponent("countdowns.json")
    }()

    init() {
        load()
    }

    func add(title: String, date: Date) {
        let item = CountdownItem(title: title, date: date)
        items.append(item)
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    private func load() {
        guard let data = try? Data(contentsOf: storageURL) else { return }
        if let decoded = try? JSONDecoder().decode([CountdownItem].self, from: data) {
            items = decoded
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: storageURL)
    }
}
