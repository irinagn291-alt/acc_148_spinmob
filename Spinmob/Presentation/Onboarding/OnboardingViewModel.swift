import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    private(set) var currentPageIndex = 0
    let pages = OnboardingPage.all

    var currentPage: OnboardingPage { pages[currentPageIndex] }
    var isLastPage: Bool { currentPageIndex == pages.count - 1 }

    func advance(onFinished: () -> Void) {
        HapticsService.lightTap()
        if isLastPage {
            onFinished()
        } else {
            currentPageIndex += 1
        }
    }
}
