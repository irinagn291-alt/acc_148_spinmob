import Foundation
import SwiftData

@MainActor
final class SwiftDataSpinHistoryRepository: SpinHistoryRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll(spinSetID: UUID) async throws -> [SpinHistoryEntry] {
        let descriptor = FetchDescriptor<SpinHistoryEntryModel>(
            predicate: #Predicate { $0.spinSetID == spinSetID },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map(\.asEntity)
    }

    func add(_ entry: SpinHistoryEntry) async throws {
        modelContext.insert(entry.asModel)
        try modelContext.save()
    }

    func deleteAll(spinSetID: UUID) async throws {
        let descriptor = FetchDescriptor<SpinHistoryEntryModel>(
            predicate: #Predicate { $0.spinSetID == spinSetID }
        )
        for model in try modelContext.fetch(descriptor) {
            modelContext.delete(model)
        }
        try modelContext.save()
    }

    func deleteAll() async throws {
        let descriptor = FetchDescriptor<SpinHistoryEntryModel>()
        for model in try modelContext.fetch(descriptor) {
            modelContext.delete(model)
        }
        try modelContext.save()
    }
}
