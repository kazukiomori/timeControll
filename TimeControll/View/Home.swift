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
                            .rotationEffect(.init(degrees: 90))
                            .animation(.none, value: pomodoroModel.progress)
                    }
                    .padding(60)
                    .frame(height: proxy.size.width)
                    .rotationEffect(.init(degrees: -90))
                    .animation(.easeInOut, value: pomodoroModel.progress)
                    
                    Button {
                        if pomodoroModel.isStarted {
                            pomodoroModel.stopTimer()
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        } else {
                            pomodoroModel.addNewTimer = true
                        }
                        
                    } label: {
                        Image(systemName: !pomodoroModel.isStarted ? "timer" : "stop.fill")
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
        .overlay(content: {
            ZStack {
                Color.black
                    .opacity(pomodoroModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        pomodoroModel.hour = 0
                        pomodoroModel.minutes = 0
                        pomodoroModel.seconds = 0
                        pomodoroModel.addNewTimer = false
                    }
                
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: pomodoroModel.addNewTimer ? 0 : 400)
            }
            .animation(.easeInOut, value: pomodoroModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
            if pomodoroModel.isStarted {
                pomodoroModel.updateTimer()
            }
        })
        .alert("完了", isPresented: $pomodoroModel.isFinished) {
            Button("再度設定する", role: .cancel) {
                pomodoroModel.stopTimer()
                pomodoroModel.addNewTimer = true
            }
            Button("閉じる", role: .destructive) {
                pomodoroModel.stopTimer()
            }

        }
    }
    
    // MARK: New Timer Button Sheet
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            Text("新しいタイマーを追加")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15){
                Text("\(pomodoroModel.hour) 時間")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 12, hint: "時間") { value in
                            pomodoroModel.hour = value
                        }
                    }
                
                Text("\(pomodoroModel.minutes) 分")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "分") { value in
                            pomodoroModel.minutes = value
                        }
                    }
                
                Text("\(pomodoroModel.seconds) 秒")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.07))
                    }
                    .contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "秒") { value in
                            pomodoroModel.seconds = value
                        }
                    }
            }
            .padding(.top, 20)
            
            Button {
                pomodoroModel.startTimer()
            } label: {
                Text("保存")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 100)
                    .padding(.vertical)
                    .background{
                        Capsule()
                            .fill(Color(.purple))
                    }
            }
            .disabled(pomodoroModel.hour == 0 &&
                      pomodoroModel.minutes == 0 &&
                      pomodoroModel.seconds == 0)
            .opacity(pomodoroModel.hour == 0 &&
                     pomodoroModel.minutes == 0 &&
                     pomodoroModel.seconds == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemGray6))
                .ignoresSafeArea()
            
        }
    }
    
    // MARK: Reusable Context Menu Options
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int)->()) -> some View {
        ForEach(0...maxValue, id: \.self) {value in
            Button("\(value) \(hint)"){
                onClick(value)
            }
        }
    }
}

#Preview {
    Home()
        .environmentObject(PomodoroModel())
}
