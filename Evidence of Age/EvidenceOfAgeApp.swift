import SwiftUI

@main
struct EvidenceOfAgeApp: App {
    @StateObject private var store = LedgerStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            AgeRootView()
                .environmentObject(store)
                .preferredColorScheme(.light)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background || phase == .inactive { store.saveNow() }
            else if phase == .active { store.rollDay() }
        }
    }
}
