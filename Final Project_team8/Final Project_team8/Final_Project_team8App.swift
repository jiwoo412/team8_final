//
//  Final_Project_team8App.swift
//  Final Project_team8
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI
import Intents

@main
struct Finalproject_jiwonApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { phase in
            INPreferences.requestSiriAuthorization { status in
            }
        }
    }
}
