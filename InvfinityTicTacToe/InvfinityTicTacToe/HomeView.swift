//
//  HomeView.swift
//  InvfinityTicTacToe
//
//  Created by Лев Куликов on 10.05.2024.
//

import SwiftUI

struct HomeView: View {
    //MARK: - Properities
    @Namespace private var namespace
    @State private var selectedGame: GameType?
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    Text("TicTacToe Games")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    OnlyThreeGameCell()
                }
                .scrollIndicators(.hidden)
                .frame(maxWidth: 500)
                
                if selectedGame == .onlyThree {
                    GameView(namespace: namespace, selectedGame: $selectedGame)
                }
            }
        }
    }
    
    //MARK: - Views
    @ViewBuilder
    private func OnlyThreeGameCell() -> some View {
        HStack {
            Image(systemName: "cube.transparent")
                .font(.system(size: 50))
                .foregroundStyle(Color.red)
            
            VStack(alignment: .leading) {
                Text("Only three")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Only three figures of each side can be on the field. If fourth added, the first one disappears")
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding()
        .frame(maxWidth: 500)
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Material.thin)
        }
        .padding()
        .onTapGesture {
            withAnimation(.snappy) {
                selectedGame = .onlyThree
            }
        }
        .matchedGeometryEffect(id: "gameview", in: namespace)
    }
    
    //MARK: - Methods
}

#Preview {
    HomeView()
}
