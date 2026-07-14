import Foundation

/// Centralized `@AppStorage` key names shared across Settings and the screens that
/// read them, so the strings only ever live in one place.
enum AppStorageKeys {
    static let isAdultContentUnlocked = "isAdultContentUnlocked"
    static let appearanceRawValue = "appearanceRawValue"
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
}
