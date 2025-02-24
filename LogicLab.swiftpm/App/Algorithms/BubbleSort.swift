import SwiftUI
import Foundation
import AVKit
import AVFoundation

struct BubbleSort: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showOverlay = false
    
    let videoLocalNames = ["BubbleSort"]
    
    @State private var numbers: [Int]
    @State private var sortedNumbers: [Int]
    @State private var expectedSwaps: [(Int, Int)] = []
    @State private var currentSwapIndex: Int = 0
    @State private var draggedIndex: Int?
    @State private var message: String = "Start sorting!!!"
    @State private var isTargetedArray: [Bool] = Array(repeating: false, count: 6)
    
    @State private var trigger: Int = 0
   
    // MARK: -Init
    init() {
        // Generate some random data
        let initialData = (0..<6).map { _ in Int.random(in: 0...49) }
        
        // Keep a sorted copy
        let sortedData = initialData.sorted()
        
        // Precompute bubble sort swaps
        let swaps = Self.calculateExpectedSwaps(numbers: initialData)
        
        // Assign to @State
        _numbers = State(initialValue: initialData)
        _sortedNumbers = State(initialValue: sortedData)
        _expectedSwaps = State(initialValue: swaps)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top, spacing: 16) {
                    VStack {
                        // How bS work
                        VStack(alignment: .leading) {
                            Text("Steps of bubble sort:")
                                .font(.largeTitle)
                                .padding(.bottom, 1)
                            
                            HStack(alignment: .center) {
                                Text("1.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Bubbble sort will take the number at first postion [index 0] and compares it with the next one.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("2.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("We have numbers [8, 3, 9, 4, 1, 6]. Number 8 is bigger than 3, so the numbers are going to be swaped.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("3.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Now numbers are [3, 8, 9, 4, 1, 6]. Number 8 is smaller than 9, so the numbers aren't swapped, we will take 9 fot the next iteration.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("4.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Now will be number 9 repeatadly compared with the next numbers [4, 1, 6] until it reached last position.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Image(systemName: "repeat")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .bold()
                                Text("This is repeated by bubble sort until the array is sorted")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            .padding(.top, -5)
                        }
                        
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
                            Text("Bubble Sort Algorithm in Swift:")
                                .font(.largeTitle)
                            
                            Text("""
                            func bubbleSort(_ array: inout [Int]) {
                            let n = array.count
                            
                            for i in 0..<n {
                                for j in 0..<(n - i - 1) {
                                    if array[j] > array[j + 1] {
                                        array.swapAt(j, j + 1)
                                        }
                                    }
                                }
                            }
                            """)
                            .font(.system(size: 20, design: .monospaced))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        Text("To open next algorithms sort this random array how would bubble sort algorithm would:")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding([.top, .horizontal])
                        
                        // Game
                        HStack(spacing: 20) {
                            ForEach(numbers.indices, id: \.self) { index in
                                let cellColor: Color = numbers[index] == sortedNumbers[safe: index]
                                    ? .green
                                    : .red
                                
                                VStack {
                                    // Num. of postion
                                    Text("\(index + 1)")
                                        .bold()
                                        .font(.title2)
                                        .underline()
                                        
                                    // Rectangle with num.
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(cellColor)
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                        .overlay(
                                            Text("\(numbers[index])")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                        )
                                        .onDrag {
                                            draggedIndex = index
                                            return NSItemProvider(object: String(index) as NSString)
                                        }
                                        // Drop → check bubble sort logic
                                        .onDrop(of: [UTType.text.identifier], isTargeted: .constant(false)) { providers in
                                            guard let provider = providers.first else { return false }
                                            provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { data, _ in
                                                if let data = data as? Data,
                                                   let sourceIndexStr = String(data: data, encoding: .utf8),
                                                   let sourceIndex = Int(sourceIndexStr) {
                                                    DispatchQueue.main.async {
                                                        handleDrop(from: sourceIndex, to: index)
                                                    }
                                                }
                                            }
                                            return true
                                        }
                                }
                            }
                        }
                        .padding(.vertical, 10)
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
                            Text("Bubble Sort")
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
                OverlayBubble(isVisible: $showOverlay)
                    .animation(.easeInOut, value: showOverlay)
            }
        }
    } //End of body
    
    // MARK: -Handle Drop
    private func handleDrop(from sourceIndex: Int, to destinationIndex: Int) {
        // Ensure index is within bounds
        guard currentSwapIndex < expectedSwaps.count else {
            message = "No more swaps expected."
            return
        }

        let expectedSwap = expectedSwaps[currentSwapIndex]  // No need for optional binding

        if (sourceIndex, destinationIndex) == expectedSwap || (destinationIndex, sourceIndex) == expectedSwap {
            // Swap the numbers
            numbers.swapAt(sourceIndex, destinationIndex)
            currentSwapIndex += 1
            message = "Correct Swap!"
            
            if currentSwapIndex >= expectedSwaps.count {
                message = "Congratulations! The array is sorted. Head back for next challenge!"
                appManager.firstAlgoCompleted = true
                appManager.lockedAlgo[1] = false
                appManager.algoProgress += 15
                trigger += 1
            }
        } else {
            message = "Not this one. Right swap would be between numbers on position \(expectedSwap.0 + 1) and \(expectedSwap.1 + 1)."
        }
    }

    
    // MARK: -Logic
    static func calculateExpectedSwaps(numbers: [Int]) -> [(Int, Int)] {
        var swaps: [(Int, Int)] = []
        var array = numbers
        let n = array.count
        
        for _ in 0..<n {
            var swapped = false
            for j in 0..<(n - 1) {
                if array[j] > array[j + 1] {
                    swaps.append((j, j + 1))
                    array.swapAt(j, j + 1)
                    swapped = true
                }
            }
            if !swapped {
                break
            }
        }
        return swaps
    }
}

// MARK: -Overlay
struct OverlayBubble: View {
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
                        Text("Bubble Sort")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        Spacer()
                    }
                    Text("""
                        Bubble Sort is a simple comparison-based sorting algorithm. It is often the first algorithm introduced in programming courses due to its straightforward logic. Bubble Sort serves as an excellent foundation for understanding more complex sorting algorithms.
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
                        Bubble Sort starts at the beginning of the list and repeatedly compares adjacent elements. If an element is larger than the one next to it, they are swapped. This process continues until a full pass is made with no swaps, indicating the list is sorted. With each pass, the largest unsorted element moves to its correct position at the end, resembling a "bubbling" effect.
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
                        Text("Educational purposes to demonstrate basic sorting concepts.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Best for small or nearly sorted datasets.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Rarely used in real-world applications due to its inefficiency (O(n²) time complexity).")
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
extension BubbleSort {
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
struct BubbleSortPreview: PreviewProvider {
    static var previews: some View {
        BubbleSort()
            .environmentObject(AppManager())
    }
}
