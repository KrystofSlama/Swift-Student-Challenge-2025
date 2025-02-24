
import SwiftUI
import Foundation
import AVKit
import AVFoundation

struct InsertionSort: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showOverlay = false
    
    let videoLocalNames = ["InsertionSort"]
    
    @State private var numbers: [Int]
    @State private var sortedNumbers: [Int]
    @State private var expectedMoves: [(fromIndex: Int, toIndex: Int)] = []
    @State private var currentMoveIndex: Int = 0
    @State private var draggedIndex: Int?
    @State private var message: String = "Start sorting!!!"
    @State private var isTargetedArray: [Bool] = Array(repeating: false, count: 6)
    
    @State private var trigger: Int = 0
   
    // MARK: -Init
    init() {
        let initialNumbers = (0..<6).map { _ in Int.random(in: 0...49) }
        
        // Precompute expected moves based on your insertion sort logic
        let (moves, originalNumbers) = Self.calculateExpectedMoves(numbers: initialNumbers)
        
        _numbers = State(initialValue: originalNumbers)
        // Keep a sorted copy to check if the block is “correct”
        _sortedNumbers = State(initialValue: originalNumbers.sorted())
        
        _expectedMoves = State(initialValue: moves)
        _isTargetedArray = State(initialValue: Array(repeating: false, count: originalNumbers.count))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top, spacing: 16) {
                    VStack {
                        // How it work
                        VStack(alignment: .leading) {
                            Text("Steps of insertion sort:")
                                .font(.largeTitle)
                                .padding(.bottom, 1)
                            
                            HStack(alignment: .center) {
                                Text("1.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Insertion sort will take the first number [index0] and assumed that number is sorted.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("2.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Then it takes second number and compares it with the first one. 3 is smaller then 8, so insertion sort swapped them.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("3.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Now numbers are [3, 8, 9, 4, 1, 6]. Now we continue with 9 which is bigger than 3 and 9, so it will stay where it is.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("4.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Now number 4 which is bigger than 3 and smaller than 9, so it will be placed between them.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Image(systemName: "repeat")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .bold()
                                Text("This is repeated by insertion sort until the array is sorted")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            .padding(.top, -5)
                        }
                        
                        // Video animation
                        if let videoURL = Bundle.main.url(forResource: videoLocalNames[0], withExtension: "mp4") {
                            PlayerInsertion(videoURL: videoURL)
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
                            func insertionSort(_ array: inout [Int]) {
                                let n = array.count
                                for i in 1..<n {
                                    let key = array[i]
                                    var j = i - 1
                                    while j >= 0 && array[j] > key {
                                        array[j + 1] = array[j]
                                        j -= 1
                                    }
                                    array[j + 1] = key
                                }
                            }
                            """)
                            .font(.system(size: 20, design: .monospaced))
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                        
                        Text("To open next algorithms sort this random array how would insertion sort algorithm would:")
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
                            Text("Insertion Sort")
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
                OverlayInsertion(isVisible: $showOverlay)
                    .animation(.easeInOut, value: showOverlay)
            }
        }
    } //End of body
    
    // MARK: -Handle Drop
    private func handleDrop(from sourceIndex: Int, to destinationIndex: Int) {
        guard let expectedMove = expectedMoves[safe: currentMoveIndex] else {
            message = "No more moves expected."
            return
        }
        
        if sourceIndex == expectedMove.fromIndex && destinationIndex == expectedMove.toIndex {
            // Perform the move
            let numberToMove = numbers.remove(at: sourceIndex)
            numbers.insert(numberToMove, at: destinationIndex)
            currentMoveIndex += 1
            message = "Correct Swap!"
            
            // If we've done all expected moves
            if currentMoveIndex >= expectedMoves.count {
                message = "Congratulations! The array is sorted. Head back for next challenge!"
                appManager.secondAlgoCompleted = true
                appManager.lockedAlgo[2] = false
                appManager.algoProgress += 15
                trigger += 1
            }
        } else {
            message = "Invalid move. Expected to move number at position \(expectedMove.fromIndex + 1) to \(expectedMove.toIndex + 1)."
        }
        draggedIndex = nil
    }
    
    // MARK: -Logic
    static func calculateExpectedMoves(numbers: [Int]) -> ([(Int, Int)], [Int]) {
        var moves: [(Int, Int)] = []
        var array = numbers
        let n = array.count
        
        for i in 1..<n {
            let key = array[i]
            var j = i - 1
            
            while j >= 0 && array[j] > key {
                j -= 1
            }
            let newPosition = j + 1
            if newPosition != i {
                moves.append((i, newPosition))
                array.remove(at: i)
                array.insert(key, at: newPosition)
            }
        }
        return (moves, numbers)
    }
}

// MARK: -Overlay
struct OverlayInsertion: View {
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
                        Text("Insertion Sort")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        Spacer()
                    }
                    Text("""
                        Insertion Sort is a simple, comparison-based sorting algorithm. It builds the final sorted array one element at a time, making it particularly effective for small datasets or nearly sorted data. While not the most efficient for large arrays, its simplicity and ease of implementation make it a good choice for basic sorting tasks.
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
                        The algorithm starts by assuming the first element is already sorted. It picks the next element and compares it with the sorted part, shifting larger elements to the right to make space for insertion. This process repeats for all elements until the list is fully sorted.
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
                        Text("Suitable for small datasets due to its simplicity.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Performs well on nearly sorted lists (adaptive).")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Used in scenarios where minimal memory usage is required, as it sorts in place with O(1) extra space.")
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

extension InsertionSort {
    struct PlayerInsertion: View {
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


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// Preview
struct InsertionSortPreview: PreviewProvider {
    static var previews: some View {
        InsertionSort()
            .environmentObject(AppManager())
    }
}
