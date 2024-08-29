//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Enes Tekneci on 6.08.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @ObservedObject var timerModel = TimerModel(studyDuration: 25 * 60, shortBreakDuration: 5 * 60, longBreakDuration: 15 * 60)
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                TimerView(timerModel: timerModel)
                    .tag(0)
                SettingsView(timerModel: timerModel)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default page indicator
            
            HStack {
                ForEach(0..<2) { index in
                    Circle()
                        .fill(index == selectedTab ? Color.red : Color.gray)
                        .frame(width: 10, height: 10)
                        .animation(.default, value: selectedTab)
                }
            }
            .padding()
        }
    }
}

struct ThirdView: View {
    var body: some View {
        Text("Third View")
            .font(.largeTitle)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding()
    }
}

#Preview {
    ContentView()
}
