import SwiftUI

struct LaborDetailView: View {
    @ObservedObject var labor: Labor
    
    var body: some View {
        Form {
            Section(header: Text("Labor Details")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(labor.name)
                }
                HStack {
                    Text("Hourly Rate")
                    Spacer()
                    Text("\(labor.hourlyRate, specifier: "%.2f")")
                }
                HStack {
                    Text("Budget Hours Worked")
                    Spacer()
                    Text("\(labor.BudgethoursWorked, specifier: "%.2f")")
                }
                HStack {
                    Text("Actual Hours Worked")
                    Spacer()
                    TextField("Actual Hours Worked", value: $labor.ActualhoursWorked, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Associated Activity")
                    Spacer()
                    Text(labor.associatedActivity.name)
                }
            }
        }
        .navigationTitle("Labor Detail")
    }
}
