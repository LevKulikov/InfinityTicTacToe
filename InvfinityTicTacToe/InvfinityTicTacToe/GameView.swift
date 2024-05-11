//
//  GameView.swift
//  InvfinityTicTacToe
//
//  Created by Лев Куликов on 10.05.2024.
//

import SwiftUI

enum GameType: CaseIterable {
    case onlyThree
}

enum TicTacToeMark {
    case xmark
    case omark
}

struct GameView: View {
    var namespace: Namespace.ID
    @Binding var selectedGame: GameType?
    
    @Environment(\.colorScheme) var colorScheme
    @State private var currentMarkPlay: TicTacToeMark = .xmark
    private let spacing: CGFloat = 8
    private var grids: [GridItem] {
        [GridItem(spacing: spacing),
         GridItem(spacing: spacing),
         GridItem(spacing: spacing)]
    }
    private var userIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        GeometryReader { proxy in
            let screenSize = proxy.size
            let maxHeight = (screenSize.height - 2 * 100) / 3 - 3 * spacing
            
            VStack {
                Spacer()
                
                LazyVGrid(columns: grids, spacing: spacing) {
                    ForEach(0..<9, id: \.self) { index in
//                        RoundedRectangle(cornerRadius: userIdiom == .phone ? 15 : 25)
//                            .fill(Color.secondary)
//                            .frame(height: maxHeight)
//                            .onTapGesture {
//                                withAnimation {
//                                    if currentMarkPlay == .xmark {
//                                        currentMarkPlay = .omark
//                                    } else {
//                                        currentMarkPlay = .xmark
//                                    }
//                                }
//                            }
                        TicTacToeCell(currentMarkPlay: $currentMarkPlay, index: index, markSize: maxHeight / 2)
                            .frame(height: maxHeight)
                    }
                }
                .padding()
                
                Spacer()
            }
            .background {
                ZStack {
                    if colorScheme == .light {
                        Color.white
                    } else {
                        Color.black
                    }
                    
                    VStack {
                        // O mark
                        XOmarkIndicatorView(mark: .omark)
                        
                        Spacer()
                        
                        // X mark
                        XOmarkIndicatorView(mark: .xmark)
                    }
                }
            }
            .overlay(alignment: .topLeading) {
                Button("Close") {
                    withAnimation(.snappy) {
                        selectedGame = nil
                    }
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.top, 50)
                .matchedGeometryEffect(id: "gameImage", in: namespace)
            }
            .matchedGeometryEffect(id: "gameview", in: namespace)
            .ignoresSafeArea(edges: .vertical)
        }
    }
    
    /// Returns appropriate figure indicator
    /// - Parameter xmark: true if xmark, false if omark
    /// - Returns: View
    @ViewBuilder
    private func XOmarkIndicatorView(mark: TicTacToeMark) -> some View {
        let alignment: Alignment = mark == .xmark ? .top : .bottom
        let color = mark == .xmark ? Color.red : Color.blue
        
        RoundedRectangle(cornerRadius: 25)
            .fill(currentMarkPlay == mark ? color.opacity(0.2) : Color.secondary.opacity(0.15))
            .frame(height: 120)
            .frame(maxWidth: 500)
            .padding(userIdiom == .phone ? 0 : spacing)
            .overlay(alignment: userIdiom == .phone ? alignment : .center) {
                Image(systemName: mark == .xmark ? "xmark" : "circle")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(currentMarkPlay == mark ? color : .secondary)
                    .shadow(color: currentMarkPlay == mark ? color : .secondary, radius: currentMarkPlay == mark ? 10 : 0)
                    .padding()
            }
    }
}

#Preview {
    @Namespace var namespace
    @State var selectedGame: GameType?
    
    return GameView(namespace: namespace, selectedGame: $selectedGame)
}
