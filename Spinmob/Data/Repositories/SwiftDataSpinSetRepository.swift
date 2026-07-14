import Foundation
import SwiftData

/// `SpinSetRepository` backed by SwiftData. Confined to the main actor because
/// `ModelContext` is not safe to share across threads.
@MainActor
final class SwiftDataSpinSetRepository: SpinSetRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() async throws -> [SpinSet] {
        let descriptor = FetchDescriptor<SpinSetModel>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try modelContext.fetch(descriptor).map(\.asEntity)
    }

    func fetch(id: UUID) async throws -> SpinSet? {
        try fetchModel(id: id)?.asEntity
    }

    func add(_ spinSet: SpinSet) async throws {
        modelContext.insert(spinSet.asModel)
        try modelContext.save()
    }

    func update(_ spinSet: SpinSet) async throws {
        guard let model = try fetchModel(id: spinSet.id) else { return }
        model.update(from: spinSet)
        try modelContext.save()
    }

    func delete(id: UUID) async throws {
        guard let model = try fetchModel(id: id) else { return }
        modelContext.delete(model)
        try modelContext.save()
    }

    private func fetchModel(id: UUID) throws -> SpinSetModel? {
        var descriptor = FetchDescriptor<SpinSetModel>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
