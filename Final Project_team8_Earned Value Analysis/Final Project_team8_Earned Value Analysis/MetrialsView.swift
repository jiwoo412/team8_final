//
//  MetrialsView.swift
//  Final Project_team8_Earned Value Analysis
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI

struct MaterialsView: View {
    @EnvironmentObject var projectExam: Project
    
    var body: some View {
        NavigationView {
            List(projectExam.Materials) { material in
                NavigationLink(destination: MaterialDetailView(material: material)) {
                    Text(material.name)
                }
            }
            .navigationTitle("Materials")
        }
    }
}
