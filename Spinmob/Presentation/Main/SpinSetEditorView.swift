import SwiftUI

struct SpinSetEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SpinSetEditorViewModel
    @AppStorage(AppStorageKeys.isAdultContentUnlocked) private var isAdultContentUnlocked = false

    init(dependencies: AppDependencies, editing spinSet: SpinSet?) {
        self._viewModel = State(initialValue: SpinSetEditorViewModel(dependencies: dependencies, editing: spinSet))
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Name") {
                    TextField("e.g. «Who does the dishes»", text: $viewModel.name)
                }

                Section("Options (min 2)") {
                    ForEach(viewModel.segments) { segment in
                        segmentRow(segment)
                    }
                    Button {
                        viewModel.addSegment()
                    } label: {
                        Label("Add Option", systemImage: "plus.circle.fill")
                    }
                }

                Section("Players (for turn-based mode)") {
                    ForEach(Array(viewModel.playerNames.enumerated()), id: \.offset) { _, player in
                        Text(player)
                    }
                    .onDelete(perform: viewModel.removePlayer)
                    HStack {
                        TextField("Player name", text: $viewModel.newPlayerName)
                        Button("Add") { viewModel.addPlayer() }
                            .disabled(viewModel.newPlayerName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                if isAdultContentUnlocked {
                    Section {
                        Toggle("This is 17+ content", isOn: $viewModel.isAdultContent)
                    } footer: {
                        Text("If it includes alcohol dares, drink in moderation and play responsibly.")
                    }
                }
            }
            .navigationTitle(viewModel.isEditingExisting ? "Edit" : "New Set")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            if await viewModel.save() != nil {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.canSave)
                }
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

    private func segmentRow(_ segment: SpinSegment) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField(
                    "Option",
                    text: Binding(
                        get: { segment.label },
                        set: { viewModel.updateLabel(id: segment.id, label: $0) }
                    )
                )
                Button {
                    viewModel.removeSegment(id: segment.id)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.red)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(StickerCatalog.all, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title3)
                            .padding(6)
                            .background(
                                segment.stickerEmoji == emoji ? AppColor.accent.opacity(0.3) : Color.clear,
                                in: Circle()
                            )
                            .onTapGesture {
                                viewModel.toggleSticker(id: segment.id, emoji: emoji)
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    SpinSetEditorView(dependencies: .previewInstance, editing: nil)
}
