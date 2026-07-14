import Foundation
import Observation

/// Drafts a new `SpinSet` or edits an existing one. Nothing is persisted until `save()`.
@Observable
@MainActor
final class SpinSetEditorViewModel {
    private let dependencies: AppDependencies
    private let editingSpinSetID: UUID?

    var name: String
    var segments: [SpinSegment]
    var playerNames: [String]
    var isAdultContent: Bool
    var newPlayerName = ""
    var errorMessage: String?

    var isEditingExisting: Bool { editingSpinSetID != nil }

    init(dependencies: AppDependencies, editing spinSet: SpinSet? = nil) {
        self.dependencies = dependencies
        self.editingSpinSetID = spinSet?.id
        self.name = spinSet?.name ?? ""
        self.segments = spinSet?.segments ?? []
        self.playerNames = spinSet?.playerNames ?? []
        self.isAdultContent = spinSet?.isAdultContent ?? false
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && segments.count >= 2
    }

    func addSegment() {
        segments.append(SpinSegment(label: ""))
    }

    func removeSegment(id: UUID) {
        segments.removeAll { $0.id == id }
    }

    func updateLabel(id: UUID, label: String) {
        guard let index = segments.firstIndex(where: { $0.id == id }) else { return }
        segments[index].label = label
    }

    func toggleSticker(id: UUID, emoji: String) {
        guard let index = segments.firstIndex(where: { $0.id == id }) else { return }
        segments[index].stickerEmoji = segments[index].stickerEmoji == emoji ? nil : emoji
    }

    func addPlayer() {
        let trimmed = newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        playerNames.append(trimmed)
        newPlayerName = ""
    }

    func removePlayer(at offsets: IndexSet) {
        playerNames.remove(atOffsets: offsets)
    }

    @discardableResult
    func save() async -> SpinSet? {
        let cleanedSegments = segments
            .map { segment -> SpinSegment in
                var copy = segment
                copy.label = segment.label.trimmingCharacters(in: .whitespacesAndNewlines)
                return copy
            }
            .filter { !$0.label.isEmpty }

        guard cleanedSegments.count >= 2 else {
            errorMessage = "You need at least 2 options."
            return nil
        }

        do {
            if let editingSpinSetID {
                let updated = SpinSet(
                    id: editingSpinSetID,
                    name: name,
                    segments: cleanedSegments,
                    playerNames: playerNames,
                    isAdultContent: isAdultContent
                )
                try await dependencies.updateSpinSetUseCase.execute(updated)
                return updated
            } else {
                return try await dependencies.createSpinSetUseCase.execute(
                    name: name,
                    segments: cleanedSegments,
                    isAdultContent: isAdultContent
                )
            }
        } catch {
            errorMessage = "Couldn't save set."
            return nil
        }
    }
}
