//
//  PomodoroModel.swift
//  TimeControll
//
//  Created by Kazuki Omori on 2024/03/01.
//

import SwiftUI

class PomodoroModel: NSObject, ObservableObject {
    // MARK: Timer Properties
    @Published var progress: CGFloat = 1
    @Published var timeStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)){isStarted = true}
        timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
    }
    
    func stopTimer() {
        
    }
    
    func updateTimer() {
        totalSeconds -= 1
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timeStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)" : "0\(minutes)"):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        if hour == 0 && minutes == 0 && seconds == 0 {
            isStarted = false
            print("タイマー終了")
        }
    }
}
