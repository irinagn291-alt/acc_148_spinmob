import SwiftData
import SwiftUI

/// Onboarding -> main-app switch, and the home for the three tabs once
/// `AppDependencies` has been built from the live `ModelContext`.
struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage(AppStorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(AppStorageKeys.appearanceRawValue) private var appearanceRawValue = AppAppearance.system.rawValue
    @State private var dependencies: AppDependencies?

    var body: some View {
        Group {
            if let dependencies {
                if hasCompletedOnboarding {
                    MainTabView(dependencies: dependencies)
                } else {
                    OnboardingView(onFinish: { hasCompletedOnboarding = true })
                }
            } else {
                ProgressView()
                    .tint(AppColor.accent)
            }
        }
        .tint(AppColor.accent)
        .preferredColorScheme((AppAppearance(rawValue: appearanceRawValue) ?? .system).colorScheme)
        .task {
            if dependencies == nil {
                dependencies = AppDependencies(modelContext: modelContext)
            }
        }
    }
}

private struct MainTabView: View {
    let dependencies: AppDependencies

    var body: some View {
        TabView {
            ArenaView(viewModel: ArenaViewModel(dependencies: dependencies))
                .tabItem { Label("Arena", systemImage: "circle.hexagongrid.fill") }

            HistoryView(viewModel: HistoryViewModel(dependencies: dependencies))
                .tabItem { Label("History", systemImage: "chart.bar.fill") }

            GlyphDecayTabView()
                .tabItem { Label("Circuit", systemImage: "bolt.circle.fill") }

            SettingsView(viewModel: SettingsViewModel(dependencies: dependencies))
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: AppSchema.allModels, inMemory: true)
}
