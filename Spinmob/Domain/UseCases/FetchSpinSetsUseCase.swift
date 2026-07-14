import Foundation

protocol FetchSpinSetsUseCase: Sendable {
    func execute() async throws -> [SpinSet]
}

struct DefaultFetchSpinSetsUseCase: FetchSpinSetsUseCase {
    let spinSetRepository: SpinSetRepository

    func execute() async throws -> [SpinSet] {
        try await spinSetRepository.fetchAll()
    }
}
