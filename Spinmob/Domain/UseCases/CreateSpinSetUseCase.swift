import Foundation

protocol CreateSpinSetUseCase: Sendable {
    func execute(name: String, segments: [SpinSegment], isAdultContent: Bool) async throws -> SpinSet
}

struct DefaultCreateSpinSetUseCase: CreateSpinSetUseCase {
    let spinSetRepository: SpinSetRepository

    func execute(name: String, segments: [SpinSegment], isAdultContent: Bool) async throws -> SpinSet {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let spinSet = SpinSet(
            name: trimmedName.isEmpty ? "Untitled" : trimmedName,
            segments: segments,
            isAdultContent: isAdultContent
        )
        try await spinSetRepository.add(spinSet)
        return spinSet
    }
}
