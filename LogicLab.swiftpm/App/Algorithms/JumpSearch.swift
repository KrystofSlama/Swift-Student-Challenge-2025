import SwiftUI
import Foundation
import AVKit
import AVFoundation

struct JumpSearch: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showOverlay = false
    
    let videoLocalNames = ["JumpSearch"]
    
    @State var numbers = (0..<7).map { _ in Int.random(in: 0...49) }
    @State var targetIndex = Int.random(in: 0...5)
    @State var targetNumber = 0
    @State var playerGuess = ""
    @State var iterations = 0
    @State var message = "Start Searching!!"
    @State var founded = false
    
    @State private var trigger: Int = 0
   
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top, spacing: 16) {
                    VStack {
                        // How bS work
                        VStack(alignment: .leading) {
                            Text("Steps of Jump Search:")
                                .font(.largeTitle)
                                .padding(.bottom, 1)
                                .onAppear {
                                    numbers = bubbleSort(numbers)
                                    getTargetNumber()
                                    jumpSearch()
                                }
                            
                            HStack(alignment: .center) {
                                Text("1.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Jump search will work only for sorted array of elements. Compares the first number with target.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("2.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Because they are not equal, jump search skippes fixed number of elements.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("3.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Compares the next one. If the number is smaller jump search would take the numbers before it.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("4.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("If it is not smaller, jump search would skip again to next element.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Image(systemName: "repeat")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .bold()
                                Text("This is repeated until jump search finds the number or reaches the end of the array.")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            .padding(.top, -5)
                        }
                        .padding(.bottom)
                        
                        // Video animation
                        if let videoURL = Bundle.main.url(forResource: videoLocalNames[0], withExtension: "mp4") {
                            CustomAVPlayerView(videoURL: videoURL)
                                .frame(width: 530, height: 200)
                        } else {
                            Text("Video not found.")
                        }
                    }
                    
                    VStack {
                        // SWIFT CODE
                        VStack(alignment: .leading) {
                            Text("Jump Search Algorithm in Swift:")
                                .font(.largeTitle)
                            
                            Text("""
                            func jumpSearch(_ array: [Int], _ target: Int) -> Int? {
                                let n = array.count
                                let step = 3  // Jump size
                                var prev = 0
                                while prev < n && array[min(prev + step, n) - 1] < target {
                                    prev += step
                                }
                                for i in prev..<min(prev + step, n) {
                                    if array[i] == target {
                                        return i 
                                    }
                                }
                                return nil
                            }
                            """)
                            .font(.system(size: 20, design: .monospaced))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        Text("How many iterations will be done before Jump Search find number: \(targetNumber).   First iteration is counted so it start from 1. Skips 1 element.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding([.horizontal])
                        
                        // Game
                        HStack(spacing: 20) {
                            ForEach(numbers.indices, id: \.self) { index in
                                VStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(numbers[index] == targetNumber ? Color.green : Color.red)
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.black, lineWidth: 2))
                                        .overlay(
                                            Text("\(numbers[index])")
                                                .font(.title2)
                                                .foregroundColor(.black))
                                }
                            }
                        }
                        
                        HStack {
                            TextField("Enter your guess", text: $playerGuess)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.title2)
                                .keyboardType(.numberPad)
                                .frame(width: 200)
                                .disabled(founded)
                            
                            Button("Check") {
                                checkGuess()
                            }
                            .font(.title2)
                            .cornerRadius(16)
                            .disabled(founded)
                        }
                        .buttonStyle(.borderedProminent)
                        // Message for game
                        Text(message)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .font(.title3)
                            .confettiCannon(trigger: $trigger)
                    }
                }
                .padding()
                .preferredColorScheme(.light)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(alignment: .center) {
                            Text("Jump Search")
                                .font(Font.system(size: 50, weight: .bold))
                                .padding(.trailing, 20)
                            
                            if #available(iOS 18.0, *) {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .fontWeight(.bold)
                                    .symbolEffect(.wiggle.byLayer, options: .repeat(.periodic(delay: 2.0)))
                                    .onTapGesture {
                                        showOverlay = true
                                    }
                            } else {
                                Image(systemName: "info.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .fontWeight(.bold)
                                    .onTapGesture {
                                        showOverlay = true
                                    }
                            }
                        }
                    }
                }
                Spacer()
            }
            if showOverlay {
                OverlayJumpSearch(isVisible: $showOverlay)
                    .animation(.easeInOut, value: showOverlay)
            }
        }
    } //End of body
    
    // MARK: -Checking Guess
    func checkGuess() {
        let playerGuessInt = Int(playerGuess) ?? 0
        
        if iterations == playerGuessInt {
            message = "Congratulations! Head back for next challenge!"
            appManager.sixthAlgoCompleted = true
            appManager.algoProgress += 15
            trigger += 1
            founded = true
        } else {
            message = "Oops! Try again!"
        }
    }

    
    // MARK: -Logic
    func bubbleSort(_ array: [Int]) -> [Int] {
        var arr = array
        let n = arr.count
        for i in 0..<n {
            for j in 0..<(n-i-1) {
                if arr[j] > arr[j+1] {
                    arr.swapAt(j, j+1)
                }
            }
        }
        return arr
    }
    
    func jumpSearch() {
        let jump = 2
        let n = numbers.count
        var index = 0
        iterations = 1
        
        while numbers[index] <= targetNumber {
            if numbers[index] == targetNumber {
                return
            }
            index += jump
            iterations += 1
        }
        
        for i in max(0, index - jump)..<min(index, n) {
            
            if numbers[i] == targetNumber {
                return
            }
            iterations += 1
        }
    }
    
    func getTargetNumber() {
        targetNumber = numbers[targetIndex]
    }
}

// MARK: -Overlay
struct OverlayJumpSearch: View {
    @Binding var isVisible: Bool
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    isVisible = false
                }
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Text("Jump Search")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        Spacer()
                    }
                    Text("""
                        Jump Search is a searching algorithm designed for sorted arrays. It works by jumping ahead in fixed steps instead of checking elements one by one, making it more efficient than Linear Search.
                        """)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("How it works")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    
                    Text("""
                        The algorithm divides the array into equal-sized blocks and jumps ahead by a fixed step size (usually √n). If the target is within a block, it performs a Linear Search inside that block. This reduces the number of comparisons compared to checking each element individually.
                        """)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("Usage")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Works only on sorted arrays.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Useful when Binary Search is not ideal, but a faster search than Linear Search is needed.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Has a time complexity of O(√n), making it more efficient than Linear Search for large datasets.")
                            .font(.title2)
                    }
                }
                .padding(20)
            }
            .frame(width: 800, height: 500)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 8)
            )
            .padding()
        }
    }
}

// MARK: -Video player
extension JumpSearch {
    struct CustomAVPlayerView: View {
        @State private var player: AVPlayer
        
        init(videoURL: URL) {
            _player = State(initialValue: AVPlayer(url: videoURL))
        }
        // Look of video player
        var body: some View {
            HStack {
                VideoPlayerView(player: player)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                    }
                Spacer()
                VStack {
                    Spacer()
                    Button(action: {
                        player.seek(to: .zero)
                        player.play()
                    }) {
                        Image(systemName: "arrow.counterclockwise.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(0.8)
                    .contentShape(Rectangle())
                }
            }
        }
    }
    
    struct VideoPlayerView: UIViewRepresentable {
        let player: AVPlayer
        
        func makeUIView(context: Context) -> UIView {
            let view = PlayerUIView(player: player)
            return view
        }
        func updateUIView(_ uiView: UIView, context: Context) {}
    }
    
    class PlayerUIView: UIView {
        private let playerLayer = AVPlayerLayer()
        
        init(player: AVPlayer) {
            super.init(frame: .zero)
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspectFill
            layer.addSublayer(playerLayer)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// Preview
struct JumpSearchPreview: PreviewProvider {
    static var previews: some View {
        JumpSearch()
            .environmentObject(AppManager())
    }
}

