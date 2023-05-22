//
//  ContentView.swift
//  Credit Card
//
//  Created by Kitwana Akil on 5/22/23.
//

import SwiftUI

struct ContentView: View {
    @State private var cardOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            CardView()
                .frame(width: 360, height: 240)
                .offset(cardOffset)
                .rotation3DEffect(
                    Angle(degrees: cardOffset != .zero ? 15 : 0),
                    axis: (x: -cardOffset.height, y: cardOffset.width, z: 0.0)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            cardOffset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                cardOffset = .zero
                            }
                        }
                )

            ParticleEmitterView()
                .frame(width: 360, height: 240)
                .offset(cardOffset)
                .rotation3DEffect(
                    Angle(degrees: cardOffset != .zero ? 15 : 0),
                    axis: (x: -cardOffset.height, y: cardOffset.width, z: 0.0)
                )
                .allowsHitTesting(false) // Add this line
        }
    }
}

struct CardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Debit Card")
                .font(.headline)
                .foregroundColor(.white)
            Text("**** 3557")
                .font(.body)
                .foregroundColor(.white)
            Spacer()
            HStack {
                Text("Valid Thru 11/25")
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "applelogo")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
        .padding(30)
        .background(gradientBackground)
        .cornerRadius(30)
        .overlay(RoundedRectangle(cornerRadius: 30).strokeBorder(gradientOutline, lineWidth: 2))
    }

    var gradientBackground: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#8E5AF7"), Color(hex: "#5D11F7")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var gradientOutline: LinearGradient {
        LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: Color.white.opacity(0.5), location: 0),
            Gradient.Stop(color: Color.clear, location: 0.5),
            Gradient.Stop(color: Color.white.opacity(0.5), location: 1)
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct ParticleEmitterView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let emitterLayer = createEmitterLayer()
        view.layer.addSublayer(emitterLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }

    private func createEmitterLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: 360, height: 240)
        emitterLayer.emitterPosition = CGPoint(x: 180, y: 120)
        emitterLayer.renderMode = .oldestFirst // Update this line
        emitterLayer.emitterCells = createEmitterCells()
        return emitterLayer
    }

    private func createEmitterCells() -> [CAEmitterCell] {
        let numberOfEmitters = 40
        return (0..<numberOfEmitters).map { index in
            let emitterCell = createEmitterCell()
            let emissionLongitude = Double(index) * (2 * Double.pi) / Double(numberOfEmitters)
            emitterCell.emissionLongitude = CGFloat(emissionLongitude)
            emitterCell.birthRate = 5 // Update this line
            emitterCell.velocity = 50 // Update this line
            emitterCell.lifetime = 1.5 // Update this line
            return emitterCell
        }
    }

    private func createEmitterCell() -> CAEmitterCell {
        let emitterCell = CAEmitterCell()

        // Custom white circle image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        let whiteCircle = renderer.image { context in
            UIColor.white.setFill()
            context.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: 20, height: 20))
        }
        emitterCell.contents = whiteCircle.cgImage

        emitterCell.birthRate = 1
        emitterCell.lifetime = 1.0
        emitterCell.scale = 0.1
        emitterCell.scaleRange = 0.02
        emitterCell.scaleSpeed = -0.05
        emitterCell.velocity = 40
        emitterCell.velocityRange = 10
        emitterCell.yAcceleration = 0
        emitterCell.alphaRange = 0.5
        emitterCell.alphaSpeed = -0.5
        return emitterCell
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
