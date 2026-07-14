import Foundation
import SwiftData

@MainActor
enum SimulatorDataSeeder {
    static let version = 1
    private static let versionKey = "spinmob.simulatorSeedVersion"

    static func seedIfNeeded(modelContext: ModelContext) {
        #if targetEnvironment(simulator)
        guard UserDefaults.standard.integer(forKey: versionKey) < version else { return }
        apply(modelContext: modelContext)
        UserDefaults.standard.set(true, forKey: AppStorageKeys.hasCompletedOnboarding)
        UserDefaults.standard.set(version, forKey: versionKey)
        #endif
    }

    #if targetEnvironment(simulator)
    private static func apply(modelContext: ModelContext) {
        let truthSetID = UUID()
        let pizzaSetID = UUID()

        let truthSegments = PartyPackTemplate.truthOrDare.makeSegments().map(\.asDTO)
        modelContext.insert(SpinSetModel(
            id: truthSetID,
            name: PartyPackTemplate.truthOrDare.name,
            segments: truthSegments,
            playerNames: ["Alex", "Sam", "Jordan"],
            isAdultContent: false,
            createdAt: .now.addingTimeInterval(-86400 * 3)
        ))

        let pizzaSegments = PartyPackTemplate.whoPaysForPizza.makeSegments().map(\.asDTO)
        modelContext.insert(SpinSetModel(
            id: pizzaSetID,
            name: PartyPackTemplate.whoPaysForPizza.name,
            segments: pizzaSegments,
            playerNames: ["Alex", "Sam"],
            isAdultContent: false,
            createdAt: .now.addingTimeInterval(-86400)
        ))

        let history: [(UUID, String, String?)] = [
            (truthSetID, "Truth", "🤐"),
            (truthSetID, "Dare", "🔥"),
            (pizzaSetID, "You're paying!", "🍕"),
            (truthSetID, "Dare", "🔥"),
            (pizzaSetID, "You got lucky this time", "😌"),
            (truthSetID, "Truth", "🤐"),
        ]
        for (index, entry) in history.enumerated() {
            modelContext.insert(SpinHistoryEntryModel(
                id: UUID(),
                spinSetID: entry.0,
                resultLabel: entry.1,
                resultStickerEmoji: entry.2,
                playerName: ["Alex", "Sam", "Jordan"][index % 3],
                date: .now.addingTimeInterval(-3600 * Double(index + 1))
            ))
        }
        try? modelContext.save()
    }
    #endif
}
