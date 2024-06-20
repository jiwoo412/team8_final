//
//  EconomicsView.swift
//  Final Project_team8_Earned Value Analysis
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI
 

struct EconomicsView: View {
    @EnvironmentObject var economicsExam: Economics
    @StateObject private var projectExam = Project()

    @State public var actualDay: Int = 5// Example current day
    @State public var earlyFinish: Int = 10 // Example early finish day
    

    var body: some View {
        Form {
            Section {
                Button(action: {
                    economicsExam.EconomicsCalculation(Materials: projectExam.Materials, ActualDay: actualDay, earlyFinish: earlyFinish)
                }) {
                    Label("Update", systemImage: "arrow.clockwise")
                }
            }
            Section {
                inputView(caption: "CPI - Cost Performance Index", value: $economicsExam.CPI)
                inputView(caption: "SPI - Schedule Performance Index", value: $economicsExam.SPI)
                percentinputView(caption: "PC - Percent Complete", value: $economicsExam.PC)
                moneyinputView(caption: "EV – Earned Value", value: $economicsExam.EV)
                moneyinputView(caption: "SV – Schedule Variance", value: $economicsExam.SV)
                moneyinputView(caption: "BAC – Budget Cost at Completion", value: $economicsExam.BAC)
                moneyinputView(caption: "EAC – Estimated Cost at Completion", value: $economicsExam.EAC)
                moneyinputView(caption: "CV – Cost Variance", value: $economicsExam.CV)
            }
        }
    }
    
    func inputView(caption: String, value: Binding<Double>) -> some View {
        let formatter: NumberFormatter = { //just to show two decimals
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.locale = Locale.current
            return formatter
        }()
        
        return HStack {
            Text(caption)
            TextField(caption, value: value, formatter: formatter)
                .multilineTextAlignment(.trailing)
        }
    }

        
    func moneyinputView(caption: String, value: Binding<Double>) -> some View {
        HStack {
            Text(caption)
            TextField(caption, value: value, format: .currency(code: "USD"))
                .multilineTextAlignment(.trailing)
        }
    }
        
    func percentinputView(caption: String, value: Binding<Double>) -> some View {
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.locale = Locale.current
            return formatter
        }()
        
        return HStack {
            Text(caption)
            TextField(caption, value: value, formatter: formatter)
                .multilineTextAlignment(.trailing)
        }
    }
}

