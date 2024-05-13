//
//  GameView.swift
//  InvfinityTicTacToe
//
//  Created by Лев Куликов on 10.05.2024.
//

import SwiftUI

enum GameType: String, CaseIterable {
    case onlyThree = "Only Three"
}

enum TicTacToeMark: String {
    case xmark = "X mark"
    case omark = "O mark"
}

struct GameView: View {
    //MARK: - Properties
    //MARK: For Init
    var namespace: Namespace.ID
    @Binding var selectedGame: GameType?
    
    //MARK: Private props
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var localNamespace
    @State private var currentMarkPlay: TicTacToeMark = .xmark
    @State private var showInfo = false
    @State private var winner: TicTacToeMark? = nil
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
    ] {
        didSet {
            winCombinationCheck()
        }
    }
    private let spacing: CGFloat = 8
    private var grids: [GridItem] {
        [GridItem(spacing: spacing),
         GridItem(spacing: spacing),
         GridItem(spacing: spacing)]
    }
    private var userIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    //MARK: - Body and Views
    //MARK: Body
    var body: some View {
        GeometryReader { proxy in
            let screenSize = proxy.size
            let maxHeight = (screenSize.height - 2 * 100) / 3 - 3 * spacing
            
            ZStack {
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
                                markPositions: $markPositions,
                                winner: $winner,
                                index: index,
                                markSize: maxHeight / 2,
                                callback: manageGame
                            )
                            .frame(height: maxHeight)
                        }
                    }
                    .padding()
                    .disabled(winner != nil)
                    .matchedGeometryEffect(id: "gameview", in: namespace)
                    
                    Spacer()
                }
                .background(markIndicators)
                .overlay(alignment: .topLeading) {
                    gameManageButton
                }
                .ignoresSafeArea(edges: .vertical)
                
                if showInfo {
                    GameInfoView(
                        namespace: localNamespace,
                        showInfo: $showInfo,
                        selectedGame: $selectedGame,
                        winner: $winner,
                        gameScheme: $gameScheme,
                        markPositions: $markPositions
                    )
                }
            }
        }
    }
    
    //MARK: Views
    private var markIndicators: some View {
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
    
    var gameManageButton: some View {
        Button("Game") {
            withAnimation(.snappy) {
                showInfo = true
            }
        }
        .buttonStyle(.bordered)
        .foregroundStyle(.secondary)
        .contentShape([.hoverEffect, .contextMenuPreview], RoundedRectangle(cornerRadius: 8.0))
        .contextMenu {
            Button("Close Game", action: closeGame)
        }
        .padding(.horizontal)
        .padding(.top, 50)
        .matchedGeometryEffect(id: "gameImage", in: namespace)
        .matchedGeometryEffect(id: "gameInfo", in: localNamespace)
        .opacity(showInfo ? 0 : 1)
    }
    
    //MARK: - Methods
    //MARK: ViewBuilder Methods
    /// Returns appropriate figure indicator
    /// - Parameter xmark: true if xmark, false if omark
    /// - Returns: View
    @ViewBuilder
    private func XOmarkIndicatorView(mark: TicTacToeMark) -> some View {
        let alignment: Alignment = mark == .xmark ? .top : .bottom
        let markColor = mark == .xmark ? Color.red : Color.blue
        let wholeIndicatorColor = currentMarkPlay == mark ? markColor : .secondary
        let winIndicatorColor = winner == mark ? Color.green : ( winner == nil ? wholeIndicatorColor : .secondary)
        
        RoundedRectangle(cornerRadius: 25)
            .fill(winIndicatorColor.opacity(0.15))
            .frame(height: 120)
            .frame(maxWidth: 500)
            .padding(userIdiom == .phone ? 0 : spacing)
            .overlay(alignment: userIdiom == .phone ? alignment : .center) {
                HStack {
                    Image(systemName: mark == .xmark ? "xmark" : "circle")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(winIndicatorColor)
                        .shadow(color: winIndicatorColor, radius: currentMarkPlay == mark ? 10 : 0)
                        .padding(.vertical)
                    
                    if winner == mark {
                        Text("Victory 🎉")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.green)
                    }
                }
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
    
    private func winCombinationCheck() {
        let combinations = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6],
        ]
        
        for certainMark in markPositions {
            let positions = certainMark.value.sorted()
            for combination in combinations {
                if positions == combination {
                    withAnimation {
                        winner = certainMark.key
                        showInfo = true
                    }
                }
            }
        }
    }
    
    private func closeGame() {
        restartGame()
        withAnimation(.snappy(duration: 0.4)) {
            selectedGame = nil
        }
    }
    
    private func restartGame() {
        withAnimation(.snappy) {
            winner = nil
            
            for index in gameScheme.keys {
                gameScheme[index] = nil
            }
            
            for index in markPositions.keys {
                markPositions[index] = []
            }
        }
    }
}

#Preview {
    @Namespace var namespace
    @State var selectedGame: GameType? = .onlyThree
    
    return GameView(namespace: namespace, selectedGame: $selectedGame)
}
