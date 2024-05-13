//
//  TicTacToeCell.swift
//  InvfinityTicTacToe
//
//  Created by Лев Куликов on 11.05.2024.
//

import SwiftUI

struct TicTacToeCell: View {
    @Binding var currentMarkPlay: TicTacToeMark
    @Binding var xoMarkSet: TicTacToeMark?
    @Binding var markPositions: [TicTacToeMark: [Int]]
    @Binding var winner: TicTacToeMark?
    let index: Int
    let markSize: CGFloat
    let callback: ((Int) -> Void)?

    @State private var deletionFlag = false
    @State private var timerStarted = false
    @State private var timer: Timer?
    private var userIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    init(currentMarkPlay: Binding<TicTacToeMark>, 
         xoMarkSet: Binding<TicTacToeMark?>,
         markPositions: Binding<[TicTacToeMark: [Int]]>,
         winner: Binding<TicTacToeMark?>,
         index: Int,
         markSize: CGFloat,
         callback: ((Int) -> Void)? = nil ) {
        self._currentMarkPlay = currentMarkPlay
        self._xoMarkSet = xoMarkSet
        self._markPositions = markPositions
        self._winner = winner
        self.index = index
        self.markSize = markSize
        self.callback = callback
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: userIdiom == .phone ? 15 : 25)
            .fill(Material.ultraThin)
            .overlay {
                if let xoMarkSet {
                    let color = xoMarkSet == .xmark ? Color.red : Color.blue
                    
                    Image(systemName: xoMarkSet == .xmark ? "xmark" : "circle")
                        .font(.system(size: markSize))
                        .fontWeight(deletionFlag ? .regular : .bold)
                        .foregroundStyle(color)
                        .opacity(deletionFlag ? 0.8 : 1)
                        .shadow(color: color, radius: deletionFlag ? 0 : 10)
                        .padding()
                }
            }
            .background {
                if let xoMarkSet {
                    RoundedRectangle(cornerRadius: userIdiom == .phone ? 15 : 25)
                        .stroke(style: StrokeStyle(lineWidth: userIdiom == .phone ? 5 : 9))
                        .fill((xoMarkSet == .xmark ? Color.red : Color.blue).opacity(deletionFlag ? 0.25 : 0.7))
                }
            }
            .onTapGesture {
                onTap()
            }
            .onChange(of: markPositions) {_ in
                checkIfWillBeDeleted()
            }
            .onChange(of: winner) {_ in
                checkIfWinner()
            }
            
    }
    
    private func onTap() {
        guard xoMarkSet == nil else { return }
        withAnimation(.snappy) {
            xoMarkSet = currentMarkPlay
            if currentMarkPlay == .xmark {
                currentMarkPlay = .omark
            } else {
                currentMarkPlay = .xmark
            }
            callback?(index)
        }
    }
    
    private func checkIfWillBeDeleted() {
        guard let xoMarkSet else { return }
        guard let allIndexes = markPositions[xoMarkSet], allIndexes.count > 2 else { return }
        let firstIndex = allIndexes.first!
        
        if firstIndex == index {
            withAnimation {
                deletionFlag = true
            }
            startTimer()
        }
    }
    
    private func checkIfWinner() {
        guard let winner else { return }
        stopTimer()
        
        if xoMarkSet == winner {
            startTimer()
        }
    }
    
    private func startTimer() {
        guard !timerStarted else { return }
        timerStarted = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            withAnimation {
                if deletionFlag {
                    deletionFlag = false
                } else {
                    deletionFlag = true
                }
            }
            
            if xoMarkSet == nil {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        timerStarted = false
        deletionFlag = false
    }
}

#Preview {
    @State var mark: TicTacToeMark = .omark
    @State var xoMarkSet: TicTacToeMark?
    @State var markPositions: [TicTacToeMark: [Int]] = [
        .xmark : [],
        .omark : []
    ]
    @State var winner: TicTacToeMark? = .omark
    
    return TicTacToeCell(currentMarkPlay: $mark, xoMarkSet: $xoMarkSet, markPositions: $markPositions, winner: $winner, index: 1, markSize: 100)
        .frame(width: 200, height: 200)
}
