//
//  TimerModel.swift
//  PomodoroTimer
//
//  Created by Enes Tekneci on 25.07.2024.
//

import Foundation
import Combine
import UserNotifications

class TimerModel: ObservableObject {
    @Published var timeRemaining: Int
    @Published var isRunning: Bool = false
    @Published var currentMode: TimerMode = .study

    enum TimerMode {
        case study
        case shortBreak
        case longBreak
    }

    @Published var initialDuration: Int
    @Published var shortBreakDuration: Int
    @Published var longBreakDuration: Int
    @Published var studySessions: Int = 0
    @Published var numberOfStreak: Int  = 4
    @Published var isAnimating: AnimationState = AnimationState(animating: false)
    
    private var timer: AnyCancellable?

    init(studyDuration: Int, shortBreakDuration: Int, longBreakDuration: Int) {
        self.timeRemaining = studyDuration
        self.initialDuration = studyDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        requestNotificationPermission()
    }

    func start() {
        isRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.cycleModes()
                }
            }
        isAnimating.animating = true
    }

    func stop() {
        isRunning = false
        timer?.cancel()
        isAnimating.animating = false
    }

    func reset(time: Int? = nil) {
        stop()
        self.timeRemaining = time ?? initialDuration
    }

    func increaseDuration(by minutes: Int = 1) {
        initialDuration += minutes * 60
        reset(time: initialDuration)
    }

    func decreaseDuration(by minutes: Int = 1) {
        initialDuration = max(60, initialDuration - minutes * 60) 
        reset(time: initialDuration)
    }

    func increaseShortBreak(by minutes: Int = 1) {
        shortBreakDuration += minutes * 60
    }

    func decreaseShortBreak(by minutes: Int = 1) {
        shortBreakDuration = max(60, shortBreakDuration - minutes * 60)
    }

    func increaseLongBreak(by minutes: Int = 1) {
        longBreakDuration += minutes * 60
    }

    func decreaseLongBreak(by minutes: Int = 1) {
        longBreakDuration = max(60, longBreakDuration - minutes * 60)
    }

    func increaseStreak(by newStreak: Int = 1){
        numberOfStreak += newStreak
    }
    
    func decreaseStreak(by newStreak: Int = 1){
        numberOfStreak -= newStreak
    }
    
    func timerCompleted() {
        scheduleNotification(for: currentMode)
    }
    
    private func cycleModes() {
        switch currentMode {
        case .study:
            studySessions += 1
            if studySessions % numberOfStreak == 0 {
                currentMode = .longBreak
                timeRemaining = longBreakDuration
                stop()
            } else {
                currentMode = .shortBreak
                timeRemaining = shortBreakDuration
                stop()
            }
        case .shortBreak, .longBreak:
            currentMode = .study
            timeRemaining = initialDuration
            stop()
            timerCompleted()
        }
    }
    
    func currentModeString(_ mode: TimerModel.TimerMode) -> String {
        switch mode {
        case .study:
            return "Study Time"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
    
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    
}

class AnimationState: ObservableObject {
    @Published var animating: Bool
    
    init(animating: Bool) {
        self.animating = animating
    }
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
        if granted {
            print("Notification permission granted.")
        } else {
            print("Notification permission denied.")
        }
    }
}

func scheduleNotification(for mode: TimerModel.TimerMode) {
    let content = UNMutableNotificationContent()
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    
    switch mode {
    case .study:
        content.title = "Study Session Complete"
        content.body = "Your study session is over. Time for a break!"
    case .shortBreak:
        content.title = "Short Break Complete"
        content.body = "Your short break is over. Back to work!"
    case .longBreak:
        content.title = "Long Break Complete"
        content.body = "Your long break is over. Time to get back to work!"
    }
    
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        }
    }
}
