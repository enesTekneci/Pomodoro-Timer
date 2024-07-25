//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Enes Tekneci on 5.08.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var timerModel: TimerModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.system(size: 50))
                    .bold()
                    .padding()
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                Stepper("Session Duration: \(timerModel.initialDuration / 60) minutes", value: Binding(
                    get: { timerModel.initialDuration / 60 },
                    set: { newValue in
                        let minutes = newValue - timerModel.initialDuration / 60
                        if minutes > 0 {
                            timerModel.increaseDuration(by: minutes)
                        } else {
                            timerModel.decreaseDuration(by: -minutes)
                        }
                        // Stop the timer when session duration changes
                        if timerModel.isRunning {
                            timerModel.reset()
                        }
                    }
                ), in: 1...60, step: 1)
                    .padding()
                    .font(.title2)
                Spacer()
            }
            Divider()
            
            HStack {
                Spacer()
                Stepper("Short Break Duration: \(timerModel.shortBreakDuration / 60) minutes", value: Binding(
                    get: { timerModel.shortBreakDuration / 60 },
                    set: { newValue in
                        let minutes = newValue - timerModel.shortBreakDuration / 60
                        if minutes > 0 {
                            timerModel.increaseShortBreak(by: minutes)
                        } else {
                            timerModel.decreaseShortBreak(by: -minutes)
                        }
                        // Stop the timer when short break duration changes
                        if timerModel.isRunning {
                            timerModel.reset()
                        }
                    }
                ), in: 1...60, step: 1)
                    .padding()
                    .font(.title2)
                Spacer()
            }
            Divider()
            
            HStack {
                Spacer()
                Stepper("Long Break Duration: \(timerModel.longBreakDuration / 60) minutes", value: Binding(
                    get: { timerModel.longBreakDuration / 60 },
                    set: { newValue in
                        let minutes = newValue - timerModel.longBreakDuration / 60
                        if minutes > 0 {
                            timerModel.increaseLongBreak(by: minutes)
                        } else {
                            timerModel.decreaseLongBreak(by: -minutes)
                        }
                        // Stop the timer when long break duration changes
                        if timerModel.isRunning {
                            timerModel.reset()
                        }
                    }
                ), in: 1...60, step: 1)
                    .padding()
                    .font(.title2)
                Spacer()
            }
            Divider()
            
            HStack {
                Spacer()
                Stepper("Number of Streaks: \(timerModel.numberOfStreak)", value: Binding(
                    get: { timerModel.numberOfStreak },
                    set: { newValue in
                        let streaks = newValue - timerModel.numberOfStreak
                        if streaks > 0 {
                            timerModel.increaseStreak(by: streaks)
                        } else {
                            timerModel.decreaseStreak(by: -streaks)
                        }
                        // Optionally stop the timer when streaks change, if needed
                        if timerModel.isRunning {
                            timerModel.reset()
                        }
                    }
                ), in: 1...25, step: 1)
                    .padding()
                    .font(.title2)
                Spacer()
            }
            Divider()
            Spacer()
            Spacer()
        }
    }
}

#Preview {
    SettingsView(timerModel: TimerModel(studyDuration: 25 * 60, shortBreakDuration: 5 * 60, longBreakDuration: 15 * 60))
}
