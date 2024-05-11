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
    //MARK: - Properties
    //MARK: For Init
    var namespace: Namespace.ID
    @Binding var selectedGame: GameType?
    
    //MARK: Private props
    @Environment(\.colorScheme) var colorScheme
    @State private var currentMarkPlay: TicTacToeMark = .xmark
    private let spacing: CGFloat = 8
    private var grids: [GridItem] {
        [GridItem(spacing: spacing),
         GridItem(spacing: spacing),
         GridItem(spacing: spacing)]
    }
    @State private var gameScheme: [Int : TicTacToeMark?] = [
        0 : nil,
        1 : nil,
        2 : nil,
        3 : nil,
        4 : nil,
        5 : nil,
        6 : nil,
        7 : nil,
        8 : nil,
    ]
    @State private var markPositions: [TicTacToeMark: [Int]] = [
        .xmark : [],
        .omark : []
    ]
    private var userIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    //MARK: - Body and Views
    //MARK: Body
    var body: some View {
        GeometryReader { proxy in
            let screenSize = proxy.size
            let maxHeight = (screenSize.height - 2 * 100) / 3 - 3 * spacing
            
            VStack {
                Spacer()
                
                LazyVGrid(columns: grids, spacing: spacing) {
                    ForEach(0..<9, id: \.self) { index in
                        TicTacToeCell(
                            currentMarkPlay: $currentMarkPlay,
                            xoMarkSet: .init(get: {
                                gameScheme[index] ?? nil
                            }, set: { newCellMark in
                                gameScheme[index] = newCellMark
                            }),
                            index: index,
                            markSize: maxHeight / 2,
                            callback: manageGame
                        )
                        .frame(height: maxHeight)
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(background)
            .overlay(alignment: .topLeading) {
                closeButton
            }
            .matchedGeometryEffect(id: "gameview", in: namespace)
            .ignoresSafeArea(edges: .vertical)
        }
    }
    
    //MARK: Views
    private var background: some View {
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
    
    private var closeButton: some View {
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
    
    //MARK: - Methods
    //MARK: ViewBuilder Methods
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
    
    //MARK: Methods
    private func manageGame(index: Int) {
        let cellMark = gameScheme[index] ?? nil
        guard let cellMark else { return }
        markPositions[cellMark]?.append(index)
        
        if var markIndexes = markPositions[cellMark] {
            if markIndexes.count > 3 {
                let firstIndex = markIndexes.removeFirst()
                markPositions[cellMark] = markIndexes
                withAnimation(.snappy) {
                    gameScheme[firstIndex] = nil
                }
            }
        }
    }
}

#Preview {
    @Namespace var namespace
    @State var selectedGame: GameType?
    
    return GameView(namespace: namespace, selectedGame: $selectedGame)
}
