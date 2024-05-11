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
    let index: Int
    let markSize: CGFloat
    let callback: ((TicTacToeMark?, Int) -> Void)?

    private var userIdiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    init(currentMarkPlay: Binding<TicTacToeMark>, xoMarkSet: Binding<TicTacToeMark?>, index: Int, markSize: CGFloat, callback: ((TicTacToeMark?, Int) -> Void)? = nil ) {
        self._currentMarkPlay = currentMarkPlay
        self._xoMarkSet = xoMarkSet
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
                        .bold()
                        .foregroundStyle(color)
                        .shadow(color: color, radius: 10)
                        .padding()
                }
            }
            .background {
                if let xoMarkSet {
                    RoundedRectangle(cornerRadius: userIdiom == .phone ? 15 : 25)
                        .stroke(style: StrokeStyle(lineWidth: 9))
                        .fill((xoMarkSet == .xmark ? Color.red : Color.blue).opacity(0.2))
                }
            }
            .onTapGesture {
                onTap()
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
            callback?(xoMarkSet, index)
        }
    }
}

#Preview {
    @State var mark: TicTacToeMark = .omark
    
    return TicTacToeCell(currentMarkPlay: $mark, xoMarkSet: .constant(nil), index: 1, markSize: 100)
        .frame(width: 200, height: 200)
}
