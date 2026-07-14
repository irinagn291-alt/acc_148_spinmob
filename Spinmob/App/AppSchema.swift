import SwiftData

/// Central registry of SwiftData model types for Spinmob.
/// Add each new @Model type to `allModels` as it is implemented.
enum AppSchema {
    static let allModels: [any PersistentModel.Type] = [
        SpinSetModel.self,
        SpinHistoryEntryModel.self
    ]
}
