import Foundation
import Observation

@Observable
@MainActor
final class SpinSetManagerViewModel {
    let dependencies: AppDependencies
    private(set) var spinSets: [SpinSet] = []
    var errorMessage: String?

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    func load() async {
        do {
            spinSets = try await dependencies.fetchSpinSetsUseCase.execute()
        } catch {
            errorMessage = "Couldn't load sets."
        }
    }

    func delete(id: UUID) async {
        do {
            try await dependencies.deleteSpinSetUseCase.execute(id: id)
            await load()
        } catch {
            errorMessage = "Couldn't delete set."
        }
    }

    @discardableResult
    func importPack(_ pack: PartyPackTemplate) async -> SpinSet? {
        do {
            let spinSet = try await dependencies.importPartyPackUseCase.execute(pack: pack)
            await load()
            return spinSet
        } catch {
            errorMessage = "Couldn't import pack."
            return nil
        }
    }
}
