import Foundation

class Labor: ObservableObject, Identifiable {
    public var id = UUID() // Conform to Identifiable with a unique UUID
    public var name: String
    public var hourlyRate: Double
    public var BudgethoursWorked: Double
    @Published public var ActualhoursWorked: Double
    public var associatedActivity: Activity
    
    init(name: String, hourlyRate: Double, BudgethoursWorked: Double, ActualhoursWorked: Double, associatedActivity: Activity) {
        self.name = name
        self.hourlyRate = hourlyRate
        self.BudgethoursWorked = BudgethoursWorked
        self.ActualhoursWorked = ActualhoursWorked
        self.associatedActivity = associatedActivity
    }
}
