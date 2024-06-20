

import Foundation

class Economics: ObservableObject {
    @Published var CPI: Double
    @Published var PC: Double
    @Published var EV: Double
    @Published var BAC: Double
    @Published var SV: Double
    @Published var EAC: Double
    @Published var CV: Double
    @Published var SPI: Double
    
    var ExtraPrices: Double
    
    @Published var BCWP: [Double]
    @Published var ACWP: [Double]
    @Published var BCWS: [Double]

    init() {
        CPI = 0.0
        PC = 0.0
        EV = 0.0
        BAC = 0.0
        SV = 0.0
        EAC = 0.0
        CV = 0.0
        SPI = 0.0
        BCWP = []
        ACWP = []
        BCWS = []
        
        ExtraPrices = 0.0
    }

    private func BCWS_func(Materials: [Material], earlyFinish: Int) -> [Double] {
        var BCWS_list: [Double] = []
        var MaterialPrice: Double = 0.0
        
        for day in stride(from: 1, to: earlyFinish+1, by: 1) {
            var BCWS_value = 0.0
            for material in Materials {
                let activity = material.associatedActivity
                if activity.earlyStart <= day {
                    let duration = Double(activity.duration)
                    let elapsed = Double(day - activity.earlyStart)
                    
                    MaterialPrice = material.BudgetPrice * material.BudgetQuantity
                    
                    BCWS_value += MaterialPrice * min(elapsed / duration, 1.0)
                }
            }
            BCWS_list.append(BCWS_value)
        }
        return BCWS_list
    }

    private func ACWP_func(Materials: [Material], ActualDay: Int) -> [Double] {
        var ACWP_list: [Double] = []
        for day in stride(from: 1, to: ActualDay+1, by: 1) {
            var ACWP_value = 0.0
            for material in Materials {
                let activity = material.associatedActivity
                if activity.earlyStart <= day {
                    let duration = Double(activity.duration)
                    let elapsed = Double(day - activity.earlyStart)
                    ACWP_value += material.ActualPrice * material.ActualQuantity * min(elapsed / duration, 1.0)
                }
            }
            ACWP_list.append(ACWP_value)
        }
        return ACWP_list
    }

    private func BCWP_func(Materials: [Material], ActualDay: Int) -> [Double] {
        var BCWP_list: [Double] = []
        for day in stride(from: 1, to: ActualDay+1, by: 1) {
            var BCWP_value = 0.0
            for material in Materials {
                let activity = material.associatedActivity
                if activity.earlyStart <= day {
                    let duration = Double(activity.duration)
                    let elapsed = Double(day - activity.earlyStart)
                    BCWP_value += material.BudgetPrice * material.ActualQuantity * min(elapsed / duration, 1.0)
                }
            }
            BCWP_list.append(BCWP_value)
        }
        return BCWP_list
    }

    private func BAC_func(Materials: [Material]) -> Double {
        var BAC_value = 0.0
        for material in Materials {
            BAC_value += material.BudgetPrice * material.BudgetQuantity
        }
        return BAC_value
    }

    private func EV_func(Materials: [Material], ActualDay: Int) -> Double {
        var EV_value = 0.0
        for material in Materials {
            let activity = material.associatedActivity
            if activity.earlyStart <= ActualDay {
                EV_value += material.BudgetPrice * material.ActualQuantity
            }
        }
        return EV_value
    }

    private func PC_func(Materials: [Material], BCWP: [Double], BAC: Double, ActualDay: Int) -> Double {
        let BCWP_value = BCWP.indices.contains(ActualDay - 1) ? BCWP[ActualDay - 1] : 0.0
        return BCWP_value / BAC
    }

    private func SV_func(BCWP: [Double], BCWS: [Double], ActualDay: Int) -> Double {
        let BCWP_value = BCWP.indices.contains(ActualDay - 1) ? BCWP[ActualDay - 1] : 0.0
        let BCWS_value = BCWS.indices.contains(ActualDay - 1) ? BCWS[ActualDay - 1] : 0.0
        return BCWP_value - BCWS_value
    }

    private func EAC_func(ACWP: [Double], BCWP: [Double], BAC: Double, ActualDay: Int) -> Double {
        let ACWP_value = ACWP.indices.contains(ActualDay - 1) ? ACWP[ActualDay - 1] : 0.0
        let BCWP_value = BCWP.indices.contains(ActualDay - 1) ? BCWP[ActualDay - 1] : 0.0
        return BCWP_value != 0.0 ? (ACWP_value / BCWP_value) * BAC : 0.0
    }

    private func CV_func(BCWP: [Double], ACWP: [Double], ActualDay: Int) -> Double {
        let BCWP_value = BCWP.indices.contains(ActualDay - 1) ? BCWP[ActualDay - 1] : 0.0
        let ACWP_value = ACWP.indices.contains(ActualDay - 1) ? ACWP[ActualDay - 1] : 0.0
        return BCWP_value - ACWP_value
    }

    private func SPI_func(BCWP: [Double], BCWS: [Double], ActualDay: Int) -> Double {
        let BCWP_value = BCWP.indices.contains(ActualDay - 1) ? BCWP[ActualDay - 1] : 0.0
        let BCWS_value = BCWS.indices.contains(ActualDay - 1) ? BCWS[ActualDay - 1] : 0.0
        return BCWS_value != 0.0 ? BCWP_value / BCWS_value : 0.0
    }
    
    private func CPI_func(BCWP: [Double], ACWP: [Double], ActualDay: Int) -> Double {
        let BCWP_value = BCWP.indices.contains(ActualDay - 1) ? BCWP[ActualDay - 1] : 0.0
        let ACWP_value = ACWP.indices.contains(ActualDay - 1) ? ACWP[ActualDay - 1] : 0.0
        return BCWP_value/ACWP_value
    }



    public func EconomicsCalculation(Materials: [Material], ActualDay: Int, earlyFinish: Int) {
        self.BCWS = BCWS_func(Materials: Materials, earlyFinish: earlyFinish)
        self.ACWP = ACWP_func(Materials: Materials, ActualDay: ActualDay)
        self.BCWP = BCWP_func(Materials: Materials, ActualDay: ActualDay)
        self.BAC = BAC_func(Materials: Materials)
        self.EV = EV_func(Materials: Materials, ActualDay: ActualDay)
        self.PC = PC_func(Materials: Materials, BCWP: self.BCWP, BAC: self.BAC, ActualDay: ActualDay)
        self.SV = SV_func(BCWP: self.BCWP, BCWS: self.BCWS, ActualDay: ActualDay)
        self.EAC = EAC_func(ACWP: self.ACWP, BCWP: self.BCWP, BAC: self.BAC, ActualDay: ActualDay)
        self.CV = CV_func(BCWP: self.BCWP, ACWP: self.ACWP, ActualDay: ActualDay)
        self.CPI = CPI_func(BCWP: self.BCWP, ACWP: self.ACWP, ActualDay: ActualDay)
        self.SPI = SPI_func(BCWP: self.BCWP, BCWS: self.BCWS, ActualDay: ActualDay)
        
        print("BCWS: \(self.BCWS)")
        print("ACWP: \(self.ACWP)")
        print("BCWP: \(self.BCWP)")
        print("BAC: \(self.BAC)")
        print("EV: \(self.EV)")
        print("PC: \(self.PC)")
        print("SV: \(self.SV)")
        print("EAC: \(self.EAC)")
        print("CV: \(self.CV)")
        print("CPI: \(self.CPI)")
        print("SPI: \(self.SPI)")
    }

}


