//
//  ContentView.swift
//  Final Project_team8
//
//  Created by 이지원 on 6/16/24.
//

import SwiftUI
import MapKit
import UserNotifications

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let cpmInfo: String
    let symbol: String
}

struct UserComment: Identifiable {
    let id = UUID()
    let text: String
    let locationName: String
}

struct ContentView: View {
    
    let locations = [
        Location(name: "Yonsei University", coordinate: CLLocationCoordinate2D(latitude: 37.566659, longitude: 126.938709), cpmInfo: "CPM: 1000", symbol: "graduationcap"),
        Location(name: "Sagrada Família", coordinate: CLLocationCoordinate2D(latitude: 41.40379074447271, longitude: 2.1743235934300698), cpmInfo: "CPM: 2000", symbol: "building.columns"),
        Location(name: "Burj Khalifa", coordinate: CLLocationCoordinate2D(latitude: 25.22110306322497, longitude: 55.27274655480405), cpmInfo: "CPM: 3000", symbol: "building")
    ]
    
    @State private var selectedLocation: Location? = nil
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
    )
    @State private var showHomeScreen = false
    @State private var comments: [UserComment] = []
    @State private var newCommentText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, annotationItems: locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Button(action: {
                            selectedLocation = location
                        }) {
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        VStack {
                                            Image(systemName: location.symbol)
                                                .foregroundColor(.red)
                                                .font(.largeTitle)
                                            Text(location.name)
                                                .font(.caption)
                                        }
                                    )
                                    .shadow(radius: 3)
                            }
                        }
                    }
                }
                .navigationTitle("Map")
                .sheet(item: $selectedLocation) { location in
                    VStack {
                        LocationDetailView(location: location)
                        
                        TextField("Enter your comment", text: $newCommentText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            addComment(for: location)
                        }) {
                            Text("Add Comment")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        Button(action: {
                            showHomeScreen = true
                        }) {
                            Text("Go to Home Screen")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        List(comments.filter { $0.locationName == location.name }) { comment in
                            VStack(alignment: .leading) {
                                Text(comment.locationName)
                                    .font(.headline)
                                Text(comment.text)
                            }
                        }
                    }
                }
                
                NavigationLink(destination: MainHomeScreen(), isActive: $showHomeScreen) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            requestNotificationPermissions()
        }
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permissions granted.")
            } else if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }
    
    func addComment(for location: Location) {
        guard !newCommentText.isEmpty else { return }
        let newComment = UserComment(text: newCommentText, locationName: location.name)
        comments.append(newComment)
        scheduleNotification(for: newComment)
        newCommentText = ""
    }
    
    func scheduleNotification(for comment: UserComment) {
        let content = UNMutableNotificationContent()
        content.title = "New Comment"
        content.body = "New comment on \(comment.locationName): \(comment.text)"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct LocationDetailView: View {
    let location: Location
    
    var body: some View {
        VStack {
            Text(location.name)
                .font(.title)
                .padding()
            Text(location.cpmInfo)
                .font(.headline)
                .padding()
        }
    }
}

struct HomeScreen: View {
    var body: some View {
        VStack {
            Text("Home Screen")
                .font(.largeTitle)
                .padding()
            NavigationLink(destination: GraphView()) {
                Text("Estimate At Completion")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.purple.opacity(0.6))
                    .foregroundColor(.white)
            }
            NavigationLink(destination: EarnedValueAnalysisView()) {
                Text("Earned Value Analysis")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue.opacity(0.6))
                    .foregroundColor(.white)
            }
            NavigationLink(destination: GraphView()) {
                Text("Show BCWS Graph")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.green.opacity(0.6))
                    .foregroundColor(.white)
            }
            NavigationLink(destination: MaterialsView()) {
                Text("Materials")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red.opacity(0.6))
                    .foregroundColor(.white)
            }
        }
    }
}

struct ChartView: View {
    var body: some View {
        Text("Graph View")
            .font(.largeTitle)
    }
}

struct EarnedValueAnalysisView: View {
    var body: some View {
        Text("Earned Value Analysis View")
            .font(.largeTitle)
    }
}

struct MaterialsView: View {
    var body: some View {
        Text("Materials View")
            .font(.largeTitle)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeScreen()
    }
}

#Preview {
    ContentView()
}

