import SwiftUI
import Foundation
import AVKit
import AVFoundation

struct LinearSearch: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showOverlay = false
    
    let videoLocalNames = ["LinearSearch"]
    
    @State var numbers = (0..<6).map { _ in Int.random(in: 0...49) }
    @State var targrtIndex = Int.random(in: 0...5)
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
                            Text("Steps of linear search:")
                                .font(.largeTitle)
                                .padding(.bottom, 1)
                                .onAppear {
                                    GetTargetNumber(numbers: numbers, targetIndex: targrtIndex)
                                    CheckingNumber(numbers: numbers)
                                }
                            
                            HStack(alignment: .center) {
                                Text("1.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Linear search will take the number on the first index.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("2.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("The number on the first index is compared with the number we are searching for.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("3.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("If the numbers are equal linear search will stop and return the index of number.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("4.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Because they are not, linear search will move to the number on next index.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Image(systemName: "repeat")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .bold()
                                Text("This is repeated until linear search finds the number or reaches the end of the array.")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            .padding(.top, -5)
                        }
                        .padding(.bottom)
                        
                        // Video animation
                        if let videoURL = Bundle.main.url(forResource: videoLocalNames[0], withExtension: "mp4") {
                            CustomAVPlayerView(videoURL: videoURL)
                                .frame(width: 500, height: 200)
                        } else {
                            Text("Video not found.")
                        }
                    }
                    
                    VStack {
                        // SWIFT CODE
                        VStack(alignment: .leading) {
                            Text("Linear Search Algorithm in Swift:")
                                .font(.largeTitle)
                            
                            Text("""
                            func linearSearch(_ array: [Int], _ target: Int) -> Int? {
                                for i in 0..<array.count {
                                    if array[i] == target {
                                        return i  // Return the index where is the right number
                                    }
                                }
                                return nil  // Return nil if the target is not found
                            }
                            """)
                            .font(.system(size: 20, design: .monospaced))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        Text("How many iterations will be done before Linear search find number: \(targetNumber).   First iteration is counted so it start from 1.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding([.top, .horizontal])
                        
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
                        .padding(.vertical, 10)
                        
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
                            .font(.title)
                            .bold()
                            .confettiCannon(trigger: $trigger)
                    }
                }
                .padding()
                .preferredColorScheme(.light)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(alignment: .center) {
                            Text("Linear Search")
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
                OverlayLinearSearch(isVisible: $showOverlay)
                    .animation(.easeInOut, value: showOverlay)
            }
        }
    } //End of body
    
    // MARK: -Checking Guess
    func checkGuess() {
        let playerGuessInt = Int(playerGuess) ?? 0
        
        if(iterations + 1 == playerGuessInt) {
            message = "Congratulations! Head back for next challenge!"
            appManager.fourthAlgoCompleted = true
            appManager.lockedAlgo[4] = false
            appManager.algoProgress += 15
            trigger += 1
            founded = true
        } else {
            message = "Oops! Try again!"
        }
    }

    // MARK: -Logic
    func CheckingNumber(numbers: [Int]) {
        let array = numbers
        
        for i in 0 ..< array.count {
            if (array[i] == targetNumber) {
                iterations = i
            }
        }
    }
    func GetTargetNumber(numbers: [Int], targetIndex: Int) {
        targetNumber = numbers[targetIndex]
    }
}

// MARK: -Overlay
struct OverlayLinearSearch: View {
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
                        Text("Linear Search")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        Spacer()
                    }
                    Text("""
                        Linear Search is a simple searching algorithm that checks each element in a list sequentially until it finds the target value or reaches the end of the list. It works on both sorted and unsorted data.
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
                        The algorithm starts from the first element and compares each element with the target value. If a match is found, it returns the index; otherwise, it moves to the next element. If the target is not in the list, it returns an indication that the element was not found.
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
                        Text("Best for small or unsorted datasets.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Useful when data is constantly changing and sorting is impractical.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Inefficient for large datasets due to its O(n) time complexity.")
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
extension LinearSearch {
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
struct LinearSearchPreview: PreviewProvider {
    static var previews: some View {
        LinearSearch()
            .environmentObject(AppManager())
    }
}

