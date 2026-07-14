import Foundation
import Observation

@Observable
@MainActor
final class ArenaViewModel {
    static let spinDuration: Double = 3.4

    let dependencies: AppDependencies
    private let rotationPlanner = WheelRotationPlanner()

    private(set) var spinSets: [SpinSet] = []
    var selectedSpinSetID: UUID?
    private(set) var isLoading = false
    private(set) var isSpinning = false
    private(set) var rotationDegrees: Double = 0
    private(set) var lastResult: SpinSegment?
    private(set) var currentTurnIndex = 0
    var errorMessage: String?
    var isShowingSetManager = false

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var selectedSpinSet: SpinSet? {
        spinSets.first { $0.id == selectedSpinSetID }
    }

    var currentPlayerName: String? {
        guard let set = selectedSpinSet, set.supportsMultiplayer else { return nil }
        return set.playerNames[currentTurnIndex % set.playerNames.count]
    }

    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }
        do {
            spinSets = try await dependencies.fetchSpinSetsUseCase.execute()
            if selectedSpinSetID == nil || !spinSets.contains(where: { $0.id == selectedSpinSetID }) {
                selectedSpinSetID = spinSets.first?.id
            }
        } catch {
            errorMessage = "Couldn't load sets."
        }
    }

    func refreshSpinSets(preserveSelection: Bool = true) async {
        do {
            spinSets = try await dependencies.fetchSpinSetsUseCase.execute()
            if !preserveSelection || !spinSets.contains(where: { $0.id == selectedSpinSetID }) {
                selectedSpinSetID = spinSets.first?.id
            }
        } catch {
            errorMessage = "Couldn't refresh sets."
        }
    }

    func selectSpinSet(id: UUID) {
        guard selectedSpinSetID != id else { return }
        selectedSpinSetID = id
        currentTurnIndex = 0
        lastResult = nil
        HapticsService.selectionChanged()
    }

    func spin() async {
        guard !isSpinning, let set = selectedSpinSet, !set.isEmpty else { return }

        isSpinning = true
        lastResult = nil

        let seed = UInt64.random(in: UInt64.min...UInt64.max)
        guard let result = dependencies.spinUseCase.execute(segments: set.segments, seed: seed),
              let targetIndex = set.segments.firstIndex(of: result) else {
            isSpinning = false
            return
        }

        rotationDegrees = rotationPlanner.nextRotation(
            segmentCount: set.segments.count,
            targetIndex: targetIndex,
            currentDegrees: rotationDegrees,
            minimumFullSpins: Int.random(in: 5...7)
        )

        await runDecelerationHaptics(duration: Self.spinDuration)

        lastResult = result
        isSpinning = false
        HapticsService.landingClimax()

        let playerName = currentPlayerName
        do {
            _ = try await dependencies.recordSpinResultUseCase.execute(
                spinSetID: set.id,
                result: result,
                playerName: playerName
            )
        } catch {
            errorMessage = "Couldn't save result."
        }

        if set.supportsMultiplayer {
            currentTurnIndex = (currentTurnIndex + 1) % set.playerNames.count
        }
    }

    private func runDecelerationHaptics(duration: Double) async {
        var elapsed = 0.0
        var interval = 0.05
        while elapsed < duration {
            try? await Task.sleep(for: .seconds(interval))
            elapsed += interval
            HapticsService.spinTick()
            interval = min(interval * 1.18, 0.4)
        }
    }
}
