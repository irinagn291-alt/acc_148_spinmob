import SwiftUI

/// Shown when there is no spin set yet, or the selected set has zero segments.
/// Copy is the spec's exact empty-state line.
struct EmptyWheelView: View {
    let onAddOptions: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "circle.dashed")
                .font(.system(size: 64))
                .foregroundStyle(AppColor.secondary)
                .neonGlow(AppColor.secondary, radius: 10)

            Text("The wheel is empty. Add names or dares — let's go!")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(AppColor.text)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button("Add Options", action: onAddOptions)
                .buttonStyle(.neon)
                .padding(.horizontal, 48)
        }
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        EmptyWheelView(onAddOptions: {})
    }
}
