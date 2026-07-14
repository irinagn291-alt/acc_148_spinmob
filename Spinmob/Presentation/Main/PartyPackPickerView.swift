import SwiftUI

/// Browse and import the built-in, ready-made party packs.
struct PartyPackPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let managerViewModel: SpinSetManagerViewModel
    let onImported: (SpinSet) -> Void

    @AppStorage(AppStorageKeys.isAdultContentUnlocked) private var isAdultContentUnlocked = false

    private var visiblePacks: [PartyPackTemplate] {
        PartyPackTemplate.all.filter { !$0.isAdultContent || isAdultContentUnlocked }
    }

    var body: some View {
        NavigationStack {
            List(visiblePacks) { pack in
                Button {
                    Task {
                        if let spinSet = await managerViewModel.importPack(pack) {
                            onImported(spinSet)
                        }
                    }
                } label: {
                    HStack {
                        Text(pack.emoji).font(.largeTitle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(pack.name).font(.body.bold()).foregroundStyle(AppColor.text)
                            Text("\(pack.segmentLabels.count) options")
                                .font(.caption)
                                .foregroundStyle(AppColor.text.opacity(0.6))
                            if pack.isAdultContent {
                                Text("17+ · drink responsibly")
                                    .font(.caption2.bold())
                                    .foregroundStyle(AppColor.primary)
                            }
                        }
                        Spacer()
                        Image(systemName: "square.and.arrow.down")
                            .foregroundStyle(AppColor.secondary)
                    }
                }
                .listRowBackground(AppColor.surface)
            }
            .scrollContentBackground(.hidden)
            .background(AppColor.background)
            .navigationTitle("Party Packs")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    PartyPackPickerView(
        managerViewModel: SpinSetManagerViewModel(dependencies: .previewInstance),
        onImported: { _ in }
    )
}
