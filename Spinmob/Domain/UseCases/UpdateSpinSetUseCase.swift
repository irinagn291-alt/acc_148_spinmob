import Foundation

protocol UpdateSpinSetUseCase: Sendable {
    func execute(_ spinSet: SpinSet) async throws
}

struct DefaultUpdateSpinSetUseCase: UpdateSpinSetUseCase {
    let spinSetRepository: SpinSetRepository

    func execute(_ spinSet: SpinSet) async throws {
        try await spinSetRepository.update(spinSet)
    }
}
