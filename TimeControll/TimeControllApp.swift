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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PomodoroModel)
        }
    }
}
