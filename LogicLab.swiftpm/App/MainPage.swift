import SwiftUI

struct MainPage: View {
    @EnvironmentObject var appManager: AppManager
    
    @State private var i: Double = 0
    @State private var isAnimating = true
    // MARK: -Body
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .monospaced()
                    .onAppear{
                        startCounter()
                    }
                    .onDisappear {
                        stopCounter()
                    }
                Spacer()
                Button(action: {
                    inital()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 220, height: 50)
                            .foregroundStyle(.gray.opacity(0.15))
                        
                        Text("WWDC Mode")
                            .foregroundStyle(.black)
                            .font(.title)
                            .bold()
                            .padding(.horizontal)
                    }
                }
            }
            
            HStack(alignment: .top, spacing: 20) {
                // MARK: -Buttons
                VStack(spacing: 20) {
                    // First Button
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .fill(AngularGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 60/255, green: 70/255, blue: 240/255, opacity: 0.99),
                                    Color(red: 210/255, green: 0/255, blue: 210/255),
                                    Color(red: 210/255, green: 0/255, blue: 210/255),
                                    Color(red: 100/255, green: 100/255, blue: 240/255, opacity: 0.7)
                                ]),
                                center: .center,
                                angle: .degrees(i)
                            )) .clipShape(RoundedRectangle(cornerRadius: 16))
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("First Task")
                                    .font(.system(size: 40, weight: .heavy))
                                    .fontDesign(.monospaced)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "command")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                    Text("Algorithms")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .fontDesign(.monospaced)
                                }
                                Spacer()
                                
                                Text("Completed: \(appManager.algoProgress)%")
                                    .font(.system(size: 35))
                                    .fontDesign(.monospaced)
                                    .fontWeight(.semibold)
                                    .padding(.bottom)
                            }
                            Spacer()
                            VStack {
                                Spacer()
                                NavigationLink {
                                    Algorithms()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 28)
                                            .opacity(0.4)
                                            .frame(width: 130, height: 50)
                                        HStack(spacing: 5) {
                                            Image(systemName: "play.fill")
                                                .bold()
                                                .font(.system(size: 20))
                                            Text("Play")
                                                .fontWeight(.bold)
                                                .font(.title)
                                        }
                                        .environmentObject(AppManager())
                                    }
                                    .foregroundStyle(.white)
                                    .padding()
                                }
                            }
                        }
                        .foregroundStyle(.white)
                        .padding([.leading, .top], 20)
                    }
                    TaskLog()
                }
                
                TerminalMainPage()
                
            }
        }
        .padding()
        .preferredColorScheme(.light)
    } // End of body
    
    func inital() {
        var i: Int = 0
        let count: Int = appManager.lockedAlgo.count
        
        if appManager.wwdcModeBool == false {
            while (i < count) {
                appManager.lockedAlgo[i] = false
                i += 1
                appManager.wwdcModeBool = true            }
        } else {
            while (i < count) {
                appManager.wwdcModeBool = false
                appManager.algoProgress = 0
                
                if (i == 0) {
                    appManager.lockedAlgo[0] = false
                } else if (i == 3) {
                    appManager.lockedAlgo[3] = false
                } else if (i == 6) {
                    appManager.lockedAlgo[6] = false
                } else {
                    appManager.lockedAlgo[i] = true
                }
                i += 1
            }
        }
    }
    
    func startCounter() {
        isAnimating = true
        Task {
            while isAnimating {
                try? await Task.sleep(nanoseconds: 10_000_000) // 10ms delay
                i = (i + 0.1).truncatingRemainder(dividingBy: 360)
            }
        }
    }
        
    func stopCounter() {
        isAnimating = false
    }
}

#Preview {
    MainPage()
        .environmentObject(AppManager())
}
