import SwiftUI

struct MaterialDetailView: View {
    @ObservedObject var material: Material

    var body: some View {
        Form {
            Section(header: Text("Material Details")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(material.name)
                }
                HStack {
                    Text("Budget Price")
                    Spacer()
                    Text("\(material.BudgetPrice, specifier: "%.2f")")
                }
                HStack {
                    Text("Budget Quantity")
                    Spacer()
                    Text("\(material.BudgetQuantity, specifier: "%.2f")")
                }
                HStack {
                    Text("Actual Price")
                    Spacer()
                    TextField("Actual Price", value: $material.ActualPrice, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Actual Quantity")
                    Spacer()
                    TextField("Actual Quantity", value: $material.ActualQuantity, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Associated Activity")
                    Spacer()
                    Text(material.associatedActivity.name)
                }
            }
        }
        .navigationTitle(material.name)
    }
}
