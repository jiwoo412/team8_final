//
//  ChartView.swift
//  Final Project_team8
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI
import Charts

struct ProjectDataPoint: Identifiable {
    let id = UUID()
    let time: Int
    let bcws: Double
    var acwp: Double?
    var bcwp: Double?
}

struct GraphView: View {
    @State private var dataPoints: [ProjectDataPoint] = []
    private let bcwsValues: [Double] = [100, 300, 600, 1000, 1600, 2400, 3400, 4600, 5600, 6000] // Predetermined BCWS values
    private let projectDuration: Int = 10 // Predetermined project duration
    @State private var currentDay: Int = 1 // Initialize current day to 1
    @State private var animatedBCWSValues: [Double] = []
    @State private var animatedACWPValues: [Double] = []
    @State private var animatedBCWPValues: [Double] = []

    var eacValues: [(Int, Double)] {
        guard let lastAcwp = dataPoints.last?.acwp else { return [] }
        let eacEnd = eac()
        
        var values: [(Int, Double)] = []
        var currentEacValue = lastAcwp
        let remainingBcws = Array(bcwsValues[currentDay-1..<projectDuration])
        let totalIncrement = remainingBcws.last! - remainingBcws.first!
        
        for (index, bcwsValue) in remainingBcws.enumerated() {
            let day = currentDay + index
            let normalizedIncrement = (bcwsValue - remainingBcws.first!) / totalIncrement
            currentEacValue = lastAcwp + normalizedIncrement * (eacEnd - lastAcwp)
            values.append((day, currentEacValue))
        }
        
        return values
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("BAC:")
                    Text("\(Int(bac()))")
                    Spacer()
                    Text("EAC:")
                    Text("\(Int(eac()))")
                }
                .padding(.horizontal)

                Chart {
                    // Plot BCWS
                    ForEach(1...projectDuration, id: \.self) { day in
                        LineMark(
                            x: .value("Time", day),
                            y: .value("BCWS", animatedBCWSValues[safe: day - 1] ?? 0),
                            series: .value("Metric", "BCWS")
                        )
                        .foregroundStyle(Color.blue)
                        .interpolationMethod(.catmullRom)
                    }

                    // Plot ACWP
                    ForEach(1...currentDay, id: \.self) { day in
                        if dataPoints.first(where: { $0.time == day })?.acwp != nil {
                            LineMark(
                                x: .value("Time", day),
                                y: .value("ACWP", animatedACWPValues[safe: day - 1] ?? 0),
                                series: .value("Metric", "ACWP")
                            )
                            .foregroundStyle(Color.red)
                            .interpolationMethod(.catmullRom)
                        }
                    }

                    // Plot BCWP
                    ForEach(1...currentDay, id: \.self) { day in
                        if dataPoints.first(where: { $0.time == day })?.bcwp != nil {
                            LineMark(
                                x: .value("Time", day),
                                y: .value("BCWP", animatedBCWPValues[safe: day - 1] ?? 0),
                                series: .value("Metric", "BCWP")
                            )
                            .foregroundStyle(Color.green)
                            .interpolationMethod(.catmullRom)
                        }
                    }

                    // Plot EAC values
                    ForEach(eacValues, id: \.0) { (day, eacValue) in
                        LineMark(
                            x: .value("Time", day),
                            y: .value("EAC", eacValue),
                            series: .value("Metric", "EAC")
                        )
                        .foregroundStyle(Color.purple)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    }
                }
                .frame(height: 300)
                .padding()

                HStack {
                    Text("")
                        .frame(width: 50, alignment: .leading)
                    Text("BCWS")
                        .frame(width: 80)
                    Text("ACWP")
                        .frame(width: 80)
                    Text("BCWP")
                        .frame(width: 80)
                }
                .padding(.horizontal)

                ForEach(1...projectDuration, id: \.self) { day in
                    HStack {
                        Text("Day \(day)")
                            .frame(width: 50, alignment: .leading)
                        Text("\(Int(bcwsValues[day - 1]))")
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                            .disabled(true)

                        TextField("ACWP", value: Binding(
                            get: {
                                if let dataPoint = dataPoints.first(where: { $0.time == day }) {
                                    return dataPoint.acwp ?? 0
                                }
                                return 0
                            },
                            set: { newValue in
                                if day <= currentDay {
                                    if let index = dataPoints.firstIndex(where: { $0.time == day }) {
                                        dataPoints[index].acwp = newValue
                                    } else {
                                        dataPoints.append(ProjectDataPoint(time: day, bcws: bcwsValues[day - 1], acwp: newValue, bcwp: nil))
                                    }
                                    animateValues(for: day)
                                }
                            }
                        ), formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                            .disabled(day > currentDay)

                        TextField("BCWP", value: Binding(
                            get: {
                                if let dataPoint = dataPoints.first(where: { $0.time == day }) {
                                    return dataPoint.bcwp ?? 0
                                }
                                return 0
                            },
                            set: { newValue in
                                if day <= currentDay {
                                    if let index = dataPoints.firstIndex(where: { $0.time == day }) {
                                        dataPoints[index].bcwp = newValue
                                    } else {
                                        dataPoints.append(ProjectDataPoint(time: day, bcws: bcwsValues[day - 1], acwp: nil, bcwp: newValue))
                                    }
                                    animateValues(for: day)
                                }
                            }
                        ), formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                            .disabled(day > currentDay)
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    if currentDay < projectDuration {
                        currentDay += 1 // Increment current day after adding new data point
                        animateValues(for: currentDay)
                    }
                }) {
                    Text("Add Data Point")
                }
                .padding()
            }
            .padding()
            .onAppear {
                // Initialize animated values with zeros
                animatedBCWSValues = Array(repeating: 0, count: bcwsValues.count)
                animatedACWPValues = Array(repeating: 0, count: bcwsValues.count)
                animatedBCWPValues = Array(repeating: 0, count: bcwsValues.count)
                
                // Animate the BCWS values upward
                for i in 0..<bcwsValues.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            animatedBCWSValues[i] = bcwsValues[i]
                        }
                    }
                }
            }
        }
    }

    func animateValues(for day: Int) {
        if let acwpValue = dataPoints.first(where: { $0.time == day })?.acwp {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedACWPValues[day - 1] = acwpValue
                }
            }
        }
        
        if let bcwpValue = dataPoints.first(where: { $0.time == day })?.bcwp {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    animatedBCWPValues[day - 1] = bcwpValue
                }
            }
        }
    }

    func bac() -> Double {
        return bcwsValues.last ?? 0
    }

    func eac() -> Double {
        if let lastAcwp = dataPoints.last?.acwp, let lastBcwp = dataPoints.last?.bcwp {
            if lastBcwp != 0 {
                return lastAcwp / (lastBcwp / bac())
            }
        }
        return 0
    }
}

struct BCWSGraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
