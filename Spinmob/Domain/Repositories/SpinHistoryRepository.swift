import Foundation

/// Abstracts persistence for `SpinHistoryEntry` so use cases never touch SwiftData directly.
protocol SpinHistoryRepository: Sendable {
    func fetchAll(spinSetID: UUID) async throws -> [SpinHistoryEntry]
    func add(_ entry: SpinHistoryEntry) async throws
    func deleteAll(spinSetID: UUID) async throws
    func deleteAll() async throws
}
