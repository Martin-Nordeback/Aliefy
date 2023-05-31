//
//  SplashScreen.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-24.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: UX & for branding our application, appears when screen is loading except openai search

import SwiftUI

struct SplashScreen: View {
    // MARK: - PROPERTIES

    @State private var startAnimation = false
    @State private var bowAnimation = false
    @State private var textAnimation: Double = 0

    @State private var glow = false
    @State private var isFinished = false

    @ObservedObject var splashScreenViewModel: SplashScreenViewModel

    // MARK: - BODY

    var body: some View {
        if !isFinished {
            ZStack {
                Image("background")
                    .ignoresSafeArea()

                GeometryReader { proxy in

                    let size = proxy.size

                    ZStack {
                        // rainbow around the logo
                        Circle()
                            .trim(from: 0, to: bowAnimation ? 0.5 : 0)
                            .stroke(
                                .linearGradient(.init(colors: [
                                    Color("Color1"),
                                    Color("Color2"),
                                    Color("Color3"),
                                    Color("Color4"),
                                    Color("Color5")
                                        .opacity(0.5),
                                ]), startPoint: .leading, endPoint: .trailing)
                                , style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                            )
                            .overlay(
                                // Glow circle
                                Circle()
                                    .fill(Color.white.opacity(0.4))
                                    .frame(width: 6, height: 6)
                                    .overlay(
                                        Circle()
                                            .fill(Color.white.opacity(glow ? 0.2 : 0.1))
                                            .frame(width: 20, height: 20)
                                    )
                                    .blur(radius: 2.5)
                                    // moving towards left...
                                    .offset(x: (size.width / 2) / 2)
                                    // moving towards bow...
                                    .rotationEffect(.init(degrees: bowAnimation ? 180 : 0))
                                    .opacity(startAnimation ? 1 : 0)
                            )
                            .frame(width: size.width / 1.9, height: size.width / 1.9)
                            .rotationEffect(.init(degrees: -200))
                            .offset(y: 10)
                        // design of the Aliefy logo
                        HStack(spacing: 10) {
                            ForEach(Array("Aliefy".enumerated()), id: \.offset) { offset, char in
                                Text(String(char))
                                    .font(.system(size: size.width / 6)) // Adjust size as needed
                                    .foregroundColor(getColorForCharacter(index: offset))
                                    .opacity(startAnimation && Double(offset) / 6.0 <= textAnimation ? 1 : 0)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(offset) * 0.3) {
                                            withAnimation(.linear(duration: 2)) {
                                                textAnimation = Double(offset + 1) / 6.0
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            } // when screen appears in the view we start the animations
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.linear(duration: 2)) {
                        bowAnimation.toggle()
                    }
                    withAnimation(.spring()) {
                        startAnimation.toggle()
                    }
                    // glow animation
                    withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                        glow.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring()) {
                            startAnimation.toggle()
                        }
                    }
                    // hiding the glow after hitting "y"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring()) {
                            startAnimation.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                splashScreenViewModel.isFinished.toggle() // sets the published bool to false, rest of the app continues
                            }
                        }
                    }
                }
            }
        }
    }

    // returns our custom made colors in each sequence of the animation of both
    func getColorForCharacter(index: Int) -> Color {
        switch index {
        case 0: return Color("Color1")
        case 1: return Color("Color2")
        case 2: return Color("Color3")
        case 3: return Color("Color4")
        case 4: return Color("Color5")
        default: return Color.white
        }
    }
}
