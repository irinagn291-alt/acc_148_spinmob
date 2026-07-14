import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    @State private var isShowingContactUs = false

    @AppStorage(AppStorageKeys.appearanceRawValue) private var appearanceRawValue = AppAppearance.system.rawValue
    @AppStorage(AppStorageKeys.isAdultContentUnlocked) private var isAdultContentUnlocked = false

    private var appearance: AppAppearance {
        AppAppearance(rawValue: appearanceRawValue) ?? .system
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Picker("Theme", selection: Binding(
                        get: { appearance },
                        set: { appearanceRawValue = $0.rawValue }
                    )) {
                        ForEach(AppAppearance.allCases) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Toggle(
                        "17+ Content",
                        isOn: Binding(
                            get: { isAdultContentUnlocked },
                            set: { newValue in
                                if newValue {
                                    viewModel.requestEnableAdultContent()
                                } else {
                                    isAdultContentUnlocked = false
                                }
                            }
                        )
                    )
                } header: {
                    Text("Age Gate")
                } footer: {
                    Text("Unlocks packs with alcohol-related dares. Off by default. No money, bets, or real prizes — this is a free party tool.")
                }

                Section("About") {
                    LabeledContent("Spinmob", value: "Let the party decide for you")
                    LabeledContent("Version", value: "1.0.0")
                    Button("Contact Us") {
                        isShowingContactUs = true
                    }
                }

                Section {
                    Button("Reset All Data", role: .destructive) {
                        viewModel.isShowingResetConfirmation = true
                    }
                } footer: {
                    Text("Deletes all sets and spin history permanently.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppColor.background)
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $viewModel.isShowingAgeGateConfirmation) {
            AgeGateConfirmationView {
                isAdultContentUnlocked = true
            }
        }
        .sheet(isPresented: $isShowingContactUs) {
            NavigationStack {
                ContactUsWebView()
            }
        }
        .confirmationDialog(
            "Reset all data?",
            isPresented: $viewModel.isShowingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) {
                Task { await viewModel.resetAllData() }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Done", isPresented: $viewModel.didReset) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("All sets and history have been deleted.")
        }
        .alert(
            "Oops!",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(dependencies: .previewInstance))
}
