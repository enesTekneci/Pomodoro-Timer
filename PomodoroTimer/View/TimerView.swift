import SwiftUI

struct TimerView: View, Observable {

    @ObservedObject var timerModel: TimerModel
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 18, dash: [3]))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 300)
                    .rotationEffect(Angle(degrees: timerModel.isAnimating.animating ? 360 : 0))
                    .animation(timerModel.isAnimating.animating ? .linear(duration: 30).repeatForever(autoreverses: false) : .default, value: timerModel.isAnimating.animating)
                        
                Text(timerModel.timeString(from: timerModel.timeRemaining))
                    .font(.system(size: 80, design: .monospaced))
                        .frame(width: 300, alignment: .center)
                        .bold()
                        .padding()
                        .fixedSize()
            }
            .padding()
            
            Text(timerModel.currentModeString(timerModel.currentMode))
                .font(.system(size: 20))
                .bold()
                .padding()
            
            HStack {
                Button(action: {
                    if timerModel.isRunning {
                        timerModel.stop()
                        withAnimation {
                            timerModel.isAnimating.animating = false
                        }
                    } else {
                        timerModel.start()
                        withAnimation {
                            timerModel.isAnimating.animating = true
                        }
                    }
                }) {
                    Text(timerModel.isRunning ? "Pause" : "Start")
                        .frame(width: 80)
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                        .padding()
                        .background(Color.red)
                        .cornerRadius(15)
                }
                .padding()
                
                Button(action: {
                    timerModel.reset()
                    withAnimation {
                        timerModel.isAnimating.animating = false
                    }
                }) {
                    Text("Reset")
                        .frame(width: 80)
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .bold()
                        .padding()
                        .background(Color.red)
                        .cornerRadius(15)
                }
                .padding()
            }
        }
    }
}

#Preview {
    TimerView(timerModel: TimerModel(studyDuration: 25 * 60, shortBreakDuration: 5 * 60, longBreakDuration: 15 * 60))
}
