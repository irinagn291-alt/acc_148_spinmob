import SwiftUI

/// Sheet for picking, creating, editing or deleting spin sets, and importing party packs.
struct SpinSetManagerView: View {
    @Environment(\.dismiss) private var dismiss
    let arenaViewModel: ArenaViewModel
    @State private var viewModel: SpinSetManagerViewModel
    @State private var isShowingEditor = false
    @State private var isShowingPackPicker = false
    @State private var editingSpinSet: SpinSet?

    init(arenaViewModel: ArenaViewModel) {
        self.arenaViewModel = arenaViewModel
        self._viewModel = State(initialValue: SpinSetManagerViewModel(dependencies: arenaViewModel.dependencies))
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.spinSets) { spinSet in
                        spinSetRow(spinSet)
                    }
                    .onDelete { offsets in
                        for index in offsets {
                            let id = viewModel.spinSets[index].id
                            Task { await delete(id: id) }
                        }
                    }
                } header: {
                    Text("My Sets")
                }

                Section {
                    Button {
                        editingSpinSet = nil
                        isShowingEditor = true
                    } label: {
                        Label("Create Set", systemImage: "plus.circle.fill")
                    }
                    Button {
                        isShowingPackPicker = true
                    } label: {
                        Label("Ready-Made Party Packs", systemImage: "sparkles")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppColor.background)
            .navigationTitle("Sets")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $isShowingEditor, onDismiss: { Task { await reloadAfterEdit() } }) {
            SpinSetEditorView(
                dependencies: arenaViewModel.dependencies,
                editing: editingSpinSet
            )
        }
        .sheet(isPresented: $isShowingPackPicker) {
            PartyPackPickerView(managerViewModel: viewModel) { spinSet in
                arenaViewModel.selectSpinSet(id: spinSet.id)
                isShowingPackPicker = false
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

    private func spinSetRow(_ spinSet: SpinSet) -> some View {
        Button {
            arenaViewModel.selectSpinSet(id: spinSet.id)
            dismiss()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(spinSet.name)
                        .font(.body.bold())
                        .foregroundStyle(AppColor.text)
                    Text("\(spinSet.segments.count) options")
                        .font(.caption)
                        .foregroundStyle(AppColor.text.opacity(0.6))
                }
                Spacer()
                if spinSet.id == arenaViewModel.selectedSpinSetID {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppColor.accent)
                }
                Button {
                    editingSpinSet = spinSet
                    isShowingEditor = true
                } label: {
                    Image(systemName: "pencil.circle")
                        .foregroundStyle(AppColor.secondary)
                }
            }
        }
        .listRowBackground(AppColor.surface)
    }

    private func delete(id: UUID) async {
        await viewModel.delete(id: id)
        await arenaViewModel.refreshSpinSets()
    }

    private func reloadAfterEdit() async {
        await viewModel.load()
        await arenaViewModel.refreshSpinSets()
    }
}

#Preview {
    SpinSetManagerView(arenaViewModel: ArenaViewModel(dependencies: .previewInstance))
}
