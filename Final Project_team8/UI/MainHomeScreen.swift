//
//  MainHomeScreen.swift
//  Final Project_team8
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI

struct MainHomeScreen: View {
    @State private var showButtons = [false, false, false, false]

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Text("Home Screen")
                        .font(.largeTitle)
                        .padding()
                        .frame(width: geometry.size.width, alignment: .center)
                        .background(Color.white)
                        .zIndex(1)
                    
                    VStack(spacing: 0) {
                        if showButtons[0] {
                            NavigationLink(destination: GraphView()) {
                                Text("Estimate At Completion")
                                    .frame(width: geometry.size.width, height: (geometry.size.height - 80) / 4)
                                    .background(Color.purple.opacity(0.6))
                                    .foregroundColor(.white)
                                    .cornerRadius(0)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }

                        if showButtons[1] {
                                Text("Earned Value Analysis")
                                    .frame(width: geometry.size.width, height: (geometry.size.height - 80) / 4)
                                    .background(Color.blue.opacity(0.6))
                                    .foregroundColor(.white)
                                    .cornerRadius(0)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }

                        if showButtons[2] {
                                Button(action: {
                                    // Action for CPM Network button (currently empty)
                                }) {
                                    Text("CPM Network")
                                        .frame(width: geometry.size.width, height: (geometry.size.height - 80) / 4) // Adjust the height if needed
                                        .background(Color.green.opacity(0.6))
                                        .foregroundColor(.white)
                                        .cornerRadius(0)
                                        .transition(.move(edge: .top).combined(with: .opacity))
                                }
                            }
                        if showButtons[3] {
                            Button(action: {
                                // Action for Comments button (currently empty)
                            }) {
                                Text("Comments")
                                    .frame(width: geometry.size.width, height: (geometry.size.height - 80) / 4) // Adjust the height if needed
                                    .background(Color.red.opacity(0.6))
                                    .foregroundColor(.white)
                                    .cornerRadius(0)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - 80)
                }
            }
            .onAppear {
                for i in 0..<showButtons.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                        withAnimation(Animation.spring()) {
                            showButtons[i] = true
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }


struct MainHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeScreen()
    }
}
