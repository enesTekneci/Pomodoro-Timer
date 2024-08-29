//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Enes Tekneci on 25.07.2024.
//

import SwiftUI

@main
struct PomodoroTimerApp: App {
    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
