import Foundation
import SwiftData

/// Lightweight dependency container, constructed once from the live
/// `ModelContext` and handed down via the SwiftUI environment.
@MainActor
final class AppDependencies {
    let spinSetRepository: SpinSetRepository
    let spinHistoryRepository: SpinHistoryRepository

    let spinUseCase: SpinUseCase
    let fetchSpinSetsUseCase: FetchSpinSetsUseCase
    let createSpinSetUseCase: CreateSpinSetUseCase
    let updateSpinSetUseCase: UpdateSpinSetUseCase
    let deleteSpinSetUseCase: DeleteSpinSetUseCase
    let importPartyPackUseCase: ImportPartyPackUseCase
    let recordSpinResultUseCase: RecordSpinResultUseCase
    let fetchSpinHistoryUseCase: FetchSpinHistoryUseCase
    let computeCurseStreakUseCase: ComputeCurseStreakUseCase
    let resetAllDataUseCase: ResetAllDataUseCase

    init(modelContext: ModelContext) {
        let spinSetRepository = SwiftDataSpinSetRepository(modelContext: modelContext)
        let spinHistoryRepository = SwiftDataSpinHistoryRepository(modelContext: modelContext)

        self.spinSetRepository = spinSetRepository
        self.spinHistoryRepository = spinHistoryRepository

        self.spinUseCase = WeightedRandomSpinUseCase()
        self.fetchSpinSetsUseCase = DefaultFetchSpinSetsUseCase(spinSetRepository: spinSetRepository)
        self.createSpinSetUseCase = DefaultCreateSpinSetUseCase(spinSetRepository: spinSetRepository)
        self.updateSpinSetUseCase = DefaultUpdateSpinSetUseCase(spinSetRepository: spinSetRepository)
        self.deleteSpinSetUseCase = DefaultDeleteSpinSetUseCase(
            spinSetRepository: spinSetRepository,
            spinHistoryRepository: spinHistoryRepository
        )
        self.importPartyPackUseCase = DefaultImportPartyPackUseCase(spinSetRepository: spinSetRepository)
        self.recordSpinResultUseCase = DefaultRecordSpinResultUseCase(spinHistoryRepository: spinHistoryRepository)
        self.fetchSpinHistoryUseCase = DefaultFetchSpinHistoryUseCase(spinHistoryRepository: spinHistoryRepository)
        self.computeCurseStreakUseCase = DefaultComputeCurseStreakUseCase()
        self.resetAllDataUseCase = DefaultResetAllDataUseCase(
            spinSetRepository: spinSetRepository,
            spinHistoryRepository: spinHistoryRepository
        )
    }
}
