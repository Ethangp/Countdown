import WidgetKit
import SwiftUI
import CountdownKit

struct CountdownEntry: TimelineEntry {
    let date: Date
    let item: CountdownItem?
}

struct CountdownProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), item: CountdownItem(title: "Sample", date: Date().addingTimeInterval(3600)))
    }

    func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> ()) {
        let entry = CountdownEntry(date: Date(), item: loadFirst())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> ()) {
        let entry = CountdownEntry(date: Date(), item: loadFirst())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadFirst() -> CountdownItem? {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.countdown")?.appendingPathComponent("countdowns.json")
        guard let url, let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode([CountdownItem].self, from: data).first
    }
}

struct CountdownWidgetEntryView : View {
    var entry: CountdownProvider.Entry

    var body: some View {
        if let item = entry.item {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(timeRemainingString(for: item))
                    .font(.body)
            }
            .padding()
        } else {
            Text("No Countdowns")
        }
    }

    private func timeRemainingString(for item: CountdownItem) -> String {
        let diff = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: item.date)
        let d = diff.day ?? 0
        let h = diff.hour ?? 0
        let m = diff.minute ?? 0
        let s = diff.second ?? 0
        return String(format: "%dd %02dh %02dm %02ds", d, h, m, s)
    }
}

@main
struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountdownProvider()) { entry in
            CountdownWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Countdown")
        .description("View your next countdown")
        .supportedFamilies([.systemSmall])
    }
}
