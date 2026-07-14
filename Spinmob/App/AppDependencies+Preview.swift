import SwiftData

/// In-memory `AppDependencies` factory for `#Preview` blocks only.
extension AppDependencies {
    @MainActor
    static var previewInstance: AppDependencies {
        let schema = Schema(AppSchema.allModels)
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return AppDependencies(modelContext: container.mainContext)
        } catch {
            fatalError("Preview ModelContainer failed: \(error)")
        }
    }
}
