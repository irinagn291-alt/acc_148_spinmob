import SwiftUI

/// Explicit 17+ confirmation required before unlocking any "adult" party pack.
struct AgeGateConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    let onConfirm: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(AppColor.primary)

                Text("17+ Content")
                    .font(.title2.bold())
                    .foregroundStyle(AppColor.text)

                Text("Packs marked 17+ may include alcohol-related dares. No money, bets, or real prizes — just party prompts. Play responsibly, drink in moderation.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppColor.text.opacity(0.8))
                    .padding(.horizontal, 12)

                Text("Confirm you are 17 or older.")
                    .font(.footnote.bold())
                    .foregroundStyle(AppColor.accent)

                VStack(spacing: 12) {
                    Button("I'm 17+, Enable") {
                        onConfirm()
                        dismiss()
                    }
                    .buttonStyle(.neon)

                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AppColor.text.opacity(0.7))
                }
                .padding(.horizontal, 24)
            }
            .padding()
            .background(AppColor.background)
        }
    }
}

#Preview {
    AgeGateConfirmationView(onConfirm: {})
}
