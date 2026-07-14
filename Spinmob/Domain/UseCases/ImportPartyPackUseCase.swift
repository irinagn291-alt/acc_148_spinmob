import Foundation

/// Materializes a built-in `PartyPackTemplate` into a real, editable `SpinSet`.
protocol ImportPartyPackUseCase: Sendable {
    func execute(pack: PartyPackTemplate) async throws -> SpinSet
}

struct DefaultImportPartyPackUseCase: ImportPartyPackUseCase {
    let spinSetRepository: SpinSetRepository

    func execute(pack: PartyPackTemplate) async throws -> SpinSet {
        let spinSet = SpinSet(
            name: pack.name,
            segments: pack.makeSegments(),
            isAdultContent: pack.isAdultContent
        )
        try await spinSetRepository.add(spinSet)
        return spinSet
    }
}
