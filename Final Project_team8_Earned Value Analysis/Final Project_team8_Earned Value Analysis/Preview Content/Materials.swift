import Foundation

class Material: ObservableObject, Identifiable {
    public var id = UUID() // Conform to Identifiable
    public var name: String
    public var BudgetPrice: Double
    public var BudgetQuantity: Double
    @Published public var ActualPrice: Double
    @Published public var ActualQuantity: Double
    public var associatedActivity: Activity
    
    init(name: String, BudgetPrice: Double, BudgetQuantity: Double, ActualPrice: Double, ActualQuantity: Double, associatedActivity: Activity) {
        self.name = name
        self.BudgetPrice = BudgetPrice
        self.BudgetQuantity = BudgetQuantity
        self.ActualPrice = ActualPrice
        self.ActualQuantity = ActualQuantity
        self.associatedActivity = associatedActivity
    }
    
    func updateActualPrice(_ price: Double) {
        self.ActualPrice = price
    }
        
    func updateActualQuantity(_ quantity: Double) {
        self.ActualQuantity = quantity
    }
}
