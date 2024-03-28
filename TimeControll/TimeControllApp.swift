//
//  TimeControllApp.swift
//  TimeControll
//
//  Created by Kazuki Omori on 2024/02/21.
//

import SwiftUI

@main
struct TimeControllApp: App {
    @StateObject var PomodoroModel: PomodoroModel = .init()
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp: Date = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PomodoroModel)
        }
        .onChange(of: phase) {_, newValue in
            if PomodoroModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                
                if newValue == .active {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if PomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        PomodoroModel.isStarted = false
                        PomodoroModel.totalSeconds = 0
                        PomodoroModel.isFinished = true
                    } else {
                        PomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
