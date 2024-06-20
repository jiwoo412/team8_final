//
//  Project.swift
//  Final Project_team8_Earned Value Analysis
//
//  Created by 이지원 on 6/16/24.
//

import Foundation

class Project: ObservableObject {
    @Published public var Materials = [Material]()
    @Published public var Labors = [Labor]()

    var activities: [Activity]

    init() {
        let activityA = Activity(id: 1, name: "Foundation", duration: 5)
        let activityB = Activity(id: 2, name: "Framing", duration: 10, predecessors: [activityA])
        let activityC = Activity(id: 3, name: "Plumbing", duration: 3, predecessors: [activityB])
        let activityD = Activity(id: 4, name: "Electrical", duration: 7, predecessors: [activityB])
        let activityE = Activity(id: 5, name: "Finishing", duration: 5, predecessors: [activityC, activityD])
        self.activities = [activityA, activityB, activityC, activityD, activityE]
        
        getMaterials(Activities: activities)
        getLabors(Activities: activities)
    }

    func getMaterials(Activities: [Activity]) {
        let MaterialA = Material(name: "Steel", BudgetPrice: 100, BudgetQuantity: 80, ActualPrice: 110, ActualQuantity: 85, associatedActivity: Activities[0])
        let MaterialB = Material(name: "Oak wood", BudgetPrice: 50, BudgetQuantity: 100, ActualPrice: 60, ActualQuantity: 100, associatedActivity: Activities[1])
        let MaterialC = Material(name: "Cotton", BudgetPrice: 30, BudgetQuantity: 10, ActualPrice: 34, ActualQuantity: 5, associatedActivity:Activities[1])
        let MaterialD = Material(name: "Brick", BudgetPrice: 80, BudgetQuantity: 100, ActualPrice: 80, ActualQuantity: 100, associatedActivity: Activities[2])
        let MaterialE = Material(name: "Pine Wood", BudgetPrice: 45, BudgetQuantity: 100, ActualPrice: 50, ActualQuantity: 105, associatedActivity: Activities[3])
        let MaterialF = Material(name: "Wool", BudgetPrice: 70, BudgetQuantity: 10, ActualPrice: 75, ActualQuantity: 10, associatedActivity: Activities[3])
        let MaterialG = Material(name: "Copper", BudgetPrice: 100, BudgetQuantity: 200, ActualPrice: 100, ActualQuantity: 200, associatedActivity: Activities[4])
        
        Materials = [MaterialA, MaterialB, MaterialC, MaterialD, MaterialE, MaterialF, MaterialG]
    }

    func getLabors(Activities: [Activity]) {
        let labor1 = Labor(name: "Carpenter", hourlyRate: 30, BudgethoursWorked: 30, ActualhoursWorked: 50, associatedActivity: Activities[1])
        let labor2 = Labor(name: "Electrician", hourlyRate: 50, BudgethoursWorked: 40, ActualhoursWorked: 40, associatedActivity: Activities[4])
        Labors = [labor1, labor2]
    }
}


