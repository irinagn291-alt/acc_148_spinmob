import Foundation

/// Abstracts persistence for `SpinSet` so use cases never touch SwiftData directly.
protocol SpinSetRepository: Sendable {
    func fetchAll() async throws -> [SpinSet]
    func fetch(id: UUID) async throws -> SpinSet?
    func add(_ spinSet: SpinSet) async throws
    func update(_ spinSet: SpinSet) async throws
    func delete(id: UUID) async throws
}
