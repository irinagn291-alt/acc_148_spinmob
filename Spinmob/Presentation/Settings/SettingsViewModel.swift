import Foundation
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    private let dependencies: AppDependencies

    var isShowingAgeGateConfirmation = false
    var isShowingResetConfirmation = false
    var didReset = false
    var errorMessage: String?

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    /// Call before flipping the toggle on; the actual flag write happens in the view's
    /// `@AppStorage` binding once the user explicitly confirms 17+ in the sheet.
    func requestEnableAdultContent() {
        isShowingAgeGateConfirmation = true
    }

    func resetAllData() async {
        do {
            try await dependencies.resetAllDataUseCase.execute()
            didReset = true
        } catch {
            errorMessage = "Couldn't reset data."
        }
    }
}
