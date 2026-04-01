import SwiftUI

fileprivate let primary = Color(red: 19/255, green: 127/255, blue: 236/255) // #137fec
fileprivate let teal = Color(red: 45/255, green: 212/255, blue: 191/255)    // #2dd4bf
fileprivate let titleColor = Color(red: 15/255, green: 23/255, blue: 42/255) // #0f172a
fileprivate let slateGray = Color(red: 100/255, green: 116/255, blue: 139/255) // #64748b

struct SplashView: View {
    @State private var isSpinning = false

    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 32)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [primary, teal]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(width: 128, height: 128)
                .shadow(color: primary.opacity(0.5), radius: 8, x: 0, y: 4)
                .overlay(
                    Image(systemName: "building.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                        .foregroundColor(.white)
                )

            VStack(spacing: 4) {
                Text("MyCity")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(titleColor)

                Text("POWERED BY NAVOICE")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(slateGray)
                    .tracking(2.0)
                    .textCase(.uppercase)
            }

            Spacer().frame(height: 32)

            Image(systemName: "arrow.2.circlepath")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(red: 209/255, green: 213/255, blue: 219/255)) // #d1d5db
                .rotationEffect(.degrees(isSpinning ? 360 : 0))
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: isSpinning)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
        .onAppear {
            isSpinning = true
        }
    }
}

#Preview {
    SplashView()
}
