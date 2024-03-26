//
//  Home.swift
//  TimeControll
//
//  Created by Kazuki Omori on 2024/03/01.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var pomodoroModel: PomodoroModel
    var body: some View {
        VStack {
            Text("ポモドーロタイマー")
                .font(.title2.bold())
                .foregroundColor(.white)
            GeometryReader { proxy in
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.03))
                            .padding(-40)
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(.white.opacity(0.03), lineWidth: 80)
                        
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(Color(.purple), lineWidth: 5)
                            .blur(radius: 15)
                            .padding(-2)
                        
                        Circle()
                            .fill(Color(.systemGray6))
                        
                        Circle()
                            .trim(from: 0, to: pomodoroModel.progress)
                            .stroke(Color(.purple).opacity(0.7), lineWidth: 10)
                        
                        GeometryReader{ proxy in
                            let size = proxy.size
                            
                            Circle()
                                .fill(Color(.purple))
                                .frame(width: 30, height: 30)
                                .overlay(content: {
                                    Circle()
                                        .fill(.white)
                                        .padding(5)
                                })
                                .frame(width: size.width,
                                       height: size.height,
                                       alignment: .center)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: pomodoroModel.progress * 360))
                            
                        }
                        
                        Text(pomodoroModel.timeStringValue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: -90))
                            .animation(.none, value: pomodoroModel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: pomodoroModel.progress)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "pause")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background{
                                Circle()
                                    .fill(Color(.purple))
                            }
                            .shadow(color: Color(.purple),radius: 8, x: 0, y: 0)
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding()
        .background{
            Color(.systemGray6)
                .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    Home()
        .environmentObject(PomodoroModel())
}
