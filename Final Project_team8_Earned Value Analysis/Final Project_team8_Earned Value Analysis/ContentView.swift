//
//  ContentView.swift
//  Final Project_team8_Earned Value Analysis
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var economicsExam: Economics
    @StateObject private var projectExam = Project()

    @State public var actualDay: Int = 5 // Example current day
    @State public var earlyFinish: Int = 10 // Example early finish day

    var body: some View {
        TabView {
            EconomicsView()
                .tabItem {
                    Label("Economics", systemImage: "dollarsign.circle")
                }
                .environmentObject(economicsExam)
            
            MaterialsView()
                .tabItem {
                    Label("Materials", systemImage: "list.bullet")
                }
                .environmentObject(projectExam)
            
            LaborCostsView()
                .tabItem {
                    Label("Labor Costs", systemImage: "hammer")
                }
                .environmentObject(projectExam)
        
        }
    }
}


