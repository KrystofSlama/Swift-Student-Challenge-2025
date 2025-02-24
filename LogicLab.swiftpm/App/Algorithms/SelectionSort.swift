
import SwiftUI
import Foundation
import AVKit
import AVFoundation

struct SelectionSort: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showOverlay = false
    
    let videoLocalNames = ["SelectionSort"]
    
    @State private var numbers: [Int] = (0..<6).map { _ in Int.random(in: 0...49) }
    @State private var expectedSwaps: [(Int, Int)] = []
    @State private var currentSwapIndex: Int = 0
    @State private var draggedIndex: Int?
    @State private var message: String = "Start Sorting!!!"
    @State private var isTargetedArray: [Bool] = Array(repeating: false, count: 6)
    
    @State private var trigger: Int = 0
    
    var sortedNumbers: [Int] {
        numbers.sorted()
    }
   
    // MARK: -Init
    init() {
        self._expectedSwaps = State(initialValue: SelectionSort.calculateExpectedSwaps(numbers: self.numbers))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top, spacing: 16) {
                    VStack {
                        // How it work
                        VStack(alignment: .leading) {
                            Text("Steps of selection sort:")
                                .font(.largeTitle)
                                .padding(.bottom, 1)
                            
                            HStack(alignment: .center) {
                                Text("1.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Selections sort will go through the array and select the smallest number.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("2.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("We have numbers [8, 3, 9, 4, 1, 6]. Number 1 is selected and swapped with 8 at index 0. And move to the next smallest.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("3.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Now numbers are [1, 3, 9, 4, 8, 6]. Number 3 already in place. We will move to the next smallest.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("4.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Now will be number 4 changed with number 9 at index 2.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Image(systemName: "repeat")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .bold()
                                Text("This is repeated by selection sort until the array is sorted.")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            .padding(.top, -5)
                        }
                        
                        // Video animation
                        if let videoURL = Bundle.main.url(forResource: videoLocalNames[0], withExtension: "mp4") {
                            PlayerSelection(videoURL: videoURL)
                                .frame(width: 500, height: 190)
                        } else {
                            Text("Video not found.")
                        }
                    }
                    
                    VStack {
                        // SWIFT CODE
                        VStack(alignment: .leading) {
                            Text("Insertion Sort Algorithm in Swift:")
                                .font(.largeTitle)
                            
                            Text("""
                                func selectionSort(_ array: inout [Int]) {
                                    let n = array.count
                                    guard n > 1 else { return }
                                    for i in 0..<n - 1 {
                                        var minIndex = i
                                        for j in (i + 1)..<n {
                                            if array[j] < array[minIndex] {
                                                minIndex = j
                                            }
                                        }
                                        if minIndex != i {
                                            array.swapAt(i, minIndex)
                                        }
                                    }
                                }
                            """)
                            .font(.system(size: 20, design: .monospaced))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        Text("To open next algorithms sort this random array how would selection sort algorithm would:")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding([.top, .horizontal])
                        
                        // Game
                        HStack(spacing: 20) {
                            ForEach(numbers.indices, id: \.self) { index in
                                let isInCorrectSpot = (numbers[index] == sortedNumbers[safe: index])
                                let blockColor = isInCorrectSpot ? Color.green : Color.red
                                
                                VStack {
                                    // Num. of postion
                                    Text("\(index + 1)")
                                        .bold()
                                        .font(.title2)
                                        .underline()
                                        .padding(.bottom, -5)
                                    // Rectangle with num.
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(blockColor)
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
                                        .onDrop(of: [UTType.text], isTargeted: $isTargetedArray[index]) { providers in
                                            guard let provider = providers.first else { return false }
                                            provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { data, _ in
                                                if let data = data as? Data,
                                                   let sourceIndexString = String(data: data, encoding: .utf8),
                                                   let sourceIndex = Int(sourceIndexString) {
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
                            Text("Selection Sort")
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
                OverlaySelectionSort(isVisible: $showOverlay)
                    .animation(.easeInOut, value: showOverlay)
            }
        }
    } //End of body
    
    // MARK: -Handle Drop
    func handleDrop(from sourceIndex: Int, to destinationIndex: Int) {
        guard let expectedSwap = expectedSwaps[safe: currentSwapIndex] else {
            message = "No more swaps expected."
            return
        }
        if (sourceIndex, destinationIndex) == expectedSwap || (destinationIndex, sourceIndex) == expectedSwap {
            // Swap the numbers
            numbers.swapAt(sourceIndex, destinationIndex)
            currentSwapIndex += 1
            message = "Correct Swap!"
            if currentSwapIndex >= expectedSwaps.count {
                message = "Congratulations! The array is sorted. Head back for next challenge!"
                appManager.thirdAlgoCompleted = true
                appManager.algoProgress += 15
                trigger += 1
            }
        } else {
            message = "Not this one. Right swap would be between numbers on position \(expectedSwap.1 + 1) and \(expectedSwap.0 + 1)."
        }
        draggedIndex = nil
    }
    
    // MARK: -Logic
    private static func calculateExpectedSwaps(numbers: [Int]) -> [(Int, Int)] {
        var swaps: [(Int, Int)] = []
        var array = numbers
        let n = array.count
        for i in 0..<n {
            var minIndex = i
            for j in (i + 1)..<n {
                if array[j] < array[minIndex] {
                    minIndex = j
                }
            }
            if minIndex != i {
                swaps.append((i, minIndex))
                array.swapAt(i, minIndex)
            }
        }
        return swaps
    }
}

// MARK: -Overlay
struct OverlaySelectionSort: View {
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
                        Text("Selection Sort")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        Spacer()
                    }
                    Text("""
                        Selection Sort is a simple comparison-based sorting algorithm. It repeatedly finds the smallest element from the unsorted part of the array and swaps it with the first unsorted element. The process continues until the entire array is sorted.
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
                        The algorithm divides the array into a sorted and an unsorted section. It scans the unsorted part to find the smallest element, then swaps it with the first unsorted element. This process repeats for each position in the array until the list is sorted.
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
                        Text("Useful for small datasets due to its simplicity.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Performs well when memory swaps are costly since it makes at most n swaps.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Not efficient for large datasets due to its O(n²) time complexity.")
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

extension SelectionSort {
    struct PlayerSelection: View {
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
struct SelectionSortPreview: PreviewProvider {
    static var previews: some View {
        SelectionSort()
            .environmentObject(AppManager())
    }
}
