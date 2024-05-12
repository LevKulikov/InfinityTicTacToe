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
                    VStack {
                        OnlyThreeGameCell()
                    }
                    .safeAreaInset(edge: .top) {
                        GeometryReader { proxy in
                            if #available(iOS 17.0, *) {
                                let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                                let scrollViewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
                                let scaleProgress = minY > 0 ? 1 + max(min(minY / scrollViewHeight, 1), 0) * 0.5 : 1
                                let reversedScaleProgress = minY < 0 ? max(((scrollViewHeight + minY) / scrollViewHeight), 0.8) : 1
                                let yOffset = minY < 0 ? -minY + max((minY / 5), -30) : 0
                                
                                titleText
                                    .scaleEffect(scaleProgress, anchor: .topLeading)
                                    .scaleEffect(reversedScaleProgress, anchor: .bottomLeading)
                                    .offset(y: yOffset)
                                    .background {
                                        Rectangle()
                                            .fill(Material.ultraThin)
                                            .padding(.bottom, -12)
                                            .padding(.top, -100)
                                            .offset(y:  yOffset)
                                            .opacity(minY >= 0 ? 0 : min(((-minY / scrollViewHeight) * (scrollViewHeight / 50)), 1))
                                    }
                            } else {
                                titleText
                            }
                        }
                        .frame(height: 50)
                    }
                }
                .scrollIndicators(.hidden)
                
                if selectedGame == .onlyThree {
                    GameView(namespace: namespace, selectedGame: $selectedGame)
                }
            }
        }
    }
    
    var titleText: some View {
        Text("TicTacToe Games")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top)
            .padding(.top)
            .opacity(selectedGame == nil ? 1 : 0)
    }
    
    //MARK: - Views
    @ViewBuilder
    private func OnlyThreeGameCell() -> some View {
        HStack {
            Image("OnlyThreeImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .frame(width: 60)
                .matchedGeometryEffect(id: "gameImage", in: namespace)
            
            VStack(alignment: .leading) {
                Text("Only three")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Only three figures of each side can be on the field. If fourth added, the first one disappears")
                    .font(.callout)
                    .foregroundStyle(Color.secondary)
            }
            .opacity(selectedGame == nil ? 1 : 0)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Material.thin)
                .matchedGeometryEffect(id: "gameview", in: namespace)
        }
        .padding()
        .onTapGesture {
            withAnimation(.snappy) {
                selectedGame = .onlyThree
            }
        }
        .frame(maxWidth: 700)
    }
    
    //MARK: - Methods
}

#Preview {
    HomeView()
}
