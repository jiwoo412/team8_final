//
//  Final_Project_team8_Earned Value Analysis.swift
//  Final Project_team8_Earned Value Analysis
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI

@main
struct MyApp: App {
    @StateObject private var economicsExam = Economics()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(economicsExam)
        }
    }
}
