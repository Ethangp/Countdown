import SwiftUI
import WidgetKit
import CountdownKit

@main
struct CountdownApp: App {
    @StateObject private var store = CountdownStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .onChange(of: store.items) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
