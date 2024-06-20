//
//  LaborCostsView.swift
//  Final Project_team8_Earned Value Analysis
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI

struct LaborCostsView: View {
    @EnvironmentObject var projectExam: Project
    
    var body: some View {
        NavigationView {
            List(projectExam.Labors) { labor in
                NavigationLink(destination: LaborDetailView(labor: labor)) {
                    VStack(alignment: .leading) {
                        Text(labor.name)
                    }
                }
            }
            .navigationTitle("Labor")
        }
    }
}
