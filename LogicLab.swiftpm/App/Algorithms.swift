import SwiftUI
import Foundation

struct Algorithms: View {
    @EnvironmentObject var appManager: AppManager
    
    @State private var i: Double = 0
    @State private var isAnimating = true
    
    private var gradientRed: [Color] = [
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 255/255, green: 0/255, blue: 0/255)
    ]
    private var gradientGreen: [Color] = [
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 255/255, blue: 0/255)
    ]
    private var gradientBlue: [Color] = [
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 0/255, blue: 0/255),
        Color(red: 0/255, green: 0/255, blue: 255/255),
        Color(red: 0/255, green: 0/255, blue: 255/255)
    ]
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        VStack {
            //Body
            HStack(spacing: 16) {
                VStack(spacing: 16) {
                    TerminalAlgo()
                        .frame(maxWidth: 400)
                    
                    TaskLogAlgo()
                        .frame(maxWidth: 400)
                }
                // Buttons
                VStack(alignment: .leading) {
                    // MARK: -First Row
                    Text("Sorting Algorithms")
                        .font(.system(size: 35, weight: .bold))
                        .padding(.bottom, -5)
                        .onAppear() {
                            startCounter()
                        }
                        .onDisappear {
                            stopCounter()
                        }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // Bubble sort First
                            ZStack {
                                if appManager.firstAlgoCompleted {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientGreen),
                                            center: .center,
                                            angle: .degrees(i)
                                        ))
                                        .frame(minWidth: 250)
                                } else if appManager.lockedAlgo[0] == true {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientRed),
                                            center: .center,
                                            angle: .degrees(i)
                                        ))
                                        .frame(minWidth: 250)
                                } else {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientBlue),
                                            center: .center,
                                            angle: .degrees(i)
                                        ))
                                        .frame(minWidth: 250)
                                }
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255))
                                    .padding(10)
                                VStack(alignment: .leading) {
                                    Text("Bubble Sort")
                                        .font(.system(size: 30, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("Algorithm")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("")
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: BubbleSort(), label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .opacity(1)
                                                    .frame(width: 120, height: 40)
                                                    .foregroundStyle(.white)
                                                if appManager.firstAlgoCompleted {
                                                    Text("Completed")
                                                        .fontWeight(.bold)
                                                        .font(.title2)
                                                        .foregroundStyle(.black)
                                                } else if appManager.lockedAlgo[0] == true {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .font(.title2)
                                                        Text("Locked")
                                                            .fontWeight(.bold)
                                                            .font(.title2)
                                                    }
                                                } else {
                                                    HStack {
                                                        Image(systemName: "play.fill")
                                                            .foregroundStyle(.black)
                                                            .font(.title2)
                                                        Text("Play")
                                                            .font(.title2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.black)
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(appManager.lockedAlgo[0] == true)
                                    }
                                }
                                .padding(20)
                            }
                                 
                            // Second Insertinon sort
                            ZStack {
                                if appManager.secondAlgoCompleted {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientGreen),
                                            center: .center,
                                            angle: .degrees(i+30)
                                        ))
                                        .frame(minWidth: 250)
                                } else if appManager.lockedAlgo[1] == true {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientRed),
                                            center: .center,
                                            angle: .degrees(i+30)
                                        ))
                                        .frame(minWidth: 250)
                                } else {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientBlue),
                                            center: .center,
                                            angle: .degrees(i+30)
                                        ))
                                        .frame(minWidth: 250)
                                }
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255))
                                    .padding(10)
                                VStack(alignment: .leading) {
                                    Text("Insertion Sort")
                                        .font(.system(size: 30, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("Algorithm")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("")
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: InsertionSort(), label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .opacity(1)
                                                    .frame(width: 120, height: 40)
                                                    .foregroundStyle(.white)
                                                if appManager.secondAlgoCompleted {
                                                    Text("Completed")
                                                        .fontWeight(.bold)
                                                        .font(.title2)
                                                        .foregroundStyle(.black)
                                                } else if appManager.lockedAlgo[1] == true {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .font(.title2)
                                                        Text("Locked")
                                                            .fontWeight(.bold)
                                                            .font(.title2)
                                                    }
                                                } else {
                                                    HStack {
                                                        Image(systemName: "play.fill")
                                                            .foregroundStyle(.black)
                                                            .font(.title2)
                                                        Text("Play")
                                                            .font(.title2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.black)
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(appManager.lockedAlgo[1] == true)
                                    }
                                }
                                .padding(20)
                            }
                            
                            // Third SelectionSort
                            ZStack {
                                if appManager.thirdAlgoCompleted {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientGreen),
                                            center: .center,
                                            angle: .degrees(i+60)
                                        ))
                                        .frame(minWidth: 250)
                                        .padding(.trailing, 20)
                                } else if appManager.lockedAlgo[2] == true {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientRed),
                                            center: .center,
                                            angle: .degrees(i+60)
                                        ))
                                        .frame(minWidth: 250)
                                        .padding(.trailing, 20)
                                } else {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientBlue),
                                            center: .center,
                                            angle: .degrees(i+60)
                                        ))
                                        .frame(minWidth: 250)
                                        .padding(.trailing, 20)
                                }
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255))
                                    .padding(10)
                                    .padding(.trailing, 20)
                                VStack(alignment: .leading) {
                                    Text("Selection Sort")
                                        .font(.system(size: 30, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("Algorithm")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("")
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: SelectionSort(), label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .opacity(1)
                                                    .frame(width: 120, height: 40)
                                                    .foregroundStyle(.white)
                                                if appManager.thirdAlgoCompleted {
                                                    Text("Completed")
                                                        .fontWeight(.bold)
                                                        .font(.title2)
                                                        .foregroundStyle(.black)
                                                } else if appManager.lockedAlgo[2] == true {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .font(.title2)
                                                        Text("Locked")
                                                            .fontWeight(.bold)
                                                            .font(.title2)
                                                    }
                                                } else {
                                                    HStack {
                                                        Image(systemName: "play.fill")
                                                            .foregroundStyle(.black)
                                                            .font(.title2)
                                                        Text("Play")
                                                            .font(.title2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.black)
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(appManager.lockedAlgo[2] == true)
                                    }
                                    .padding(.trailing, 20)
                                }
                                .padding(20)
                            }
                        }
                    }
                    
                    // MARK: -Second Row
                    Text("Searching Algorithms")
                        .font(.system(size: 35, weight: .bold))
                        .padding(.bottom, -5)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // Bubble sort First
                            ZStack {
                                if appManager.fourthAlgoCompleted {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientGreen),
                                            center: .center,
                                            angle: .degrees(i+90)
                                        ))
                                        .frame(minWidth: 250)
                                } else if appManager.lockedAlgo[3] == true {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientRed),
                                            center: .center,
                                            angle: .degrees(i+90)
                                        ))
                                        .frame(minWidth: 250)
                                } else {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientBlue),
                                            center: .center,
                                            angle: .degrees(i+90)
                                        ))
                                        .frame(minWidth: 250)
                                }
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255))
                                    .padding(10)
                                VStack(alignment: .leading) {
                                    Text("Linear Search")
                                        .font(.system(size: 30, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("Algorithm")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("")
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: LinearSearch(), label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .opacity(1)
                                                    .frame(width: 120, height: 40)
                                                    .foregroundStyle(.white)
                                                if appManager.fourthAlgoCompleted {
                                                    Text("Completed")
                                                        .fontWeight(.bold)
                                                        .font(.title2)
                                                        .foregroundStyle(.black)
                                                } else if appManager.lockedAlgo[3] == true {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .font(.title2)
                                                        Text("Locked")
                                                            .fontWeight(.bold)
                                                            .font(.title2)
                                                    }
                                                } else {
                                                    HStack {
                                                        Image(systemName: "play.fill")
                                                            .foregroundStyle(.black)
                                                            .font(.title2)
                                                        Text("Play")
                                                            .font(.title2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.black)
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(appManager.lockedAlgo[3] == true)
                                    }
                                }
                                .padding(20)
                            }
                                 
                            // Second Binary Search
                            ZStack {
                                if appManager.fifthAlgoCompleted {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientGreen),
                                            center: .center,
                                            angle: .degrees(i+120)
                                        ))
                                        .frame(minWidth: 250)
                                } else if appManager.lockedAlgo[4] == true {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientRed),
                                            center: .center,
                                            angle: .degrees(i+120)
                                        ))
                                        .frame(minWidth: 250)
                                } else {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientBlue),
                                            center: .center,
                                            angle: .degrees(i+120)
                                        ))
                                        .frame(minWidth: 250)
                                }
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255))
                                    .padding(10)
                                VStack(alignment: .leading) {
                                    Text("Binary Search")
                                        .font(.system(size: 30, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("Algorithm")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("")
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: BinarySearch(), label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .opacity(1)
                                                    .frame(width: 120, height: 40)
                                                    .foregroundStyle(.white)
                                                if appManager.fifthAlgoCompleted {
                                                    Text("Completed")
                                                        .fontWeight(.bold)
                                                        .font(.title2)
                                                        .foregroundStyle(.black)
                                                } else if appManager.lockedAlgo[4] == true {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .font(.title2)
                                                        Text("Locked")
                                                            .fontWeight(.bold)
                                                            .font(.title2)
                                                    }
                                                } else {
                                                    HStack {
                                                        Image(systemName: "play.fill")
                                                            .foregroundStyle(.black)
                                                            .font(.title2)
                                                        Text("Play")
                                                            .font(.title2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.black)
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(appManager.lockedAlgo[4] == true)
                                    }
                                }
                                .padding(20)
                            }
                            
                            // Third Jump Search
                            ZStack {
                                if appManager.sixthAlgoCompleted {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientGreen),
                                            center: .center,
                                            angle: .degrees(i+150)
                                        ))
                                        .frame(minWidth: 250)
                                        .padding(.trailing, 20)
                                } else if appManager.lockedAlgo[5] == true {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientRed),
                                            center: .center,
                                            angle: .degrees(i+150)
                                        ))
                                        .frame(minWidth: 250)
                                        .padding(.trailing, 20)
                                } else {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientBlue),
                                            center: .center,
                                            angle: .degrees(i+150)
                                        ))
                                        .frame(minWidth: 250)
                                        .padding(.trailing, 20)
                                }
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255))
                                    .padding(10)
                                    .padding(.trailing, 20)
                                VStack(alignment: .leading) {
                                    Text("Jump Search")
                                        .font(.system(size: 30, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("Algorithm")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("")
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: JumpSearch(), label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .opacity(1)
                                                    .frame(width: 120, height: 40)
                                                    .foregroundStyle(.white)
                                                if appManager.sixthAlgoCompleted {
                                                    Text("Completed")
                                                        .fontWeight(.bold)
                                                        .font(.title2)
                                                        .foregroundStyle(.black)
                                                } else if appManager.lockedAlgo[5] == true {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .font(.title2)
                                                        Text("Locked")
                                                            .fontWeight(.bold)
                                                            .font(.title2)
                                                    }
                                                } else {
                                                    HStack {
                                                        Image(systemName: "play.fill")
                                                            .foregroundStyle(.black)
                                                            .font(.title2)
                                                        Text("Play")
                                                            .font(.title2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.black)
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(appManager.lockedAlgo[5] == true)
                                    }
                                    .padding(.trailing, 20)
                                }
                                .padding(20)
                            }
                        }
                    }
                    
                    // MARK: -Third Row
                    Text("Other Algorithms")
                        .font(.system(size: 35, weight: .bold))
                        .padding(.bottom, -5)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // First Dijkstras
                            ZStack {
                                if appManager.seventhAlgoCompleted {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientGreen),
                                            center: .center,
                                            angle: .degrees(i+180)
                                        ))
                                        .frame(minWidth: 250)
                                } else if appManager.lockedAlgo[6] == true {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientRed),
                                            center: .center,
                                            angle: .degrees(i+180)
                                        ))
                                        .frame(minWidth: 250)
                                } else {
                                    RoundedRectangle(cornerRadius: 26)
                                        .fill(AngularGradient(
                                            gradient: Gradient(colors: gradientBlue),
                                            center: .center,
                                            angle: .degrees(i+180)
                                        ))
                                        .frame(minWidth: 250)
                                }
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color(red: 0/255, green: 0/255, blue: 0/255))
                                    .padding(10)
                                VStack(alignment: .leading) {
                                    Text("Dijkstra's")
                                        .font(.system(size: 30, weight: .semibold))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("Algorithm")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                    Text("")
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: DijkstrasAlgo(), label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .opacity(1)
                                                    .frame(width: 120, height: 40)
                                                    .foregroundStyle(.white)
                                                if appManager.seventhAlgoCompleted {
                                                    Text("Completed")
                                                        .fontWeight(.bold)
                                                        .font(.title2)
                                                        .foregroundStyle(.black)
                                                } else if appManager.lockedAlgo[6] == true {
                                                    HStack {
                                                        Image(systemName: "lock.fill")
                                                            .font(.title2)
                                                        Text("Locked")
                                                            .fontWeight(.bold)
                                                            .font(.title2)
                                                    }
                                                } else {
                                                    HStack {
                                                        Image(systemName: "play.fill")
                                                            .foregroundStyle(.black)
                                                            .font(.title2)
                                                        Text("Play")
                                                            .font(.title2)
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.black)
                                                    }
                                                }
                                            }
                                        })
                                        .disabled(appManager.lockedAlgo[6] == true)
                                    }
                                }
                                .padding(20)
                            }   
                        }
                    }
                }
            }
        }
        .padding(.leading)
        .preferredColorScheme(.light)
        
    }
    
    func startCounter() {
        isAnimating = true
        Task {
            while isAnimating {
                try? await Task.sleep(nanoseconds: 10_000_00) // 10ms delay
                i = (i + 0.1).truncatingRemainder(dividingBy: 360)
            }
        }
    }
        
    func stopCounter() {
        isAnimating = false
    }
}

#Preview {
    Algorithms()
        .environmentObject(AppManager())
}

