//
//  ContentView.swift
//  TimeControll
//
//  Created by Kazuki Omori on 2024/02/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var PomodoroModel: PomodoroModel
    var body: some View {
        Home()
            .environmentObject(PomodoroModel)
    }
}

#Preview {
    ContentView()
}
