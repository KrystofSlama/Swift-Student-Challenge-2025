import SwiftUI
import Foundation
import AVKit
import AVFoundation

struct DijkstrasAlgo: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showOverlay = false
    
    let videoLocalNames = ["Dijkstra"]
    
    @State var playerGuess = ""
    @State var message = "Find the path!"
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
                            Text("Steps of Dijkstra Algorithm:")
                                .font(.largeTitle)
                                .padding(.bottom, 1)
                            
                            HStack(alignment: .center) {
                                Text("1.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Dijsktra starts from starting point and marks all nodes as unvisited.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("2.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Pick the neighbor node with the minimum distance from the source node.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("3.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Check neighbor path if is there smaller distance then update it.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Text("4.")
                                    .font(Font.system(size: 50, weight: .bold))
                                Text("Mark the current node as visited.")
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 5)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            HStack(alignment: .center) {
                                Image(systemName: "repeat")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .bold()
                                Text("This is repeated until all nodes are visited or the destination is found.")
                                    .multilineTextAlignment(.leading)
                                    .font(.title2)
                            }.fixedSize(horizontal: false, vertical: true)
                            .padding(.top, -5)
                        }
                        
                        // Video animation
                        if let videoURL = Bundle.main.url(forResource: videoLocalNames[0], withExtension: "mp4") {
                            CustomAVPlayerView(videoURL: videoURL)
                                .frame(width: 440, height: 280)
                        } else {
                            Text("Video not found.")
                        }
                    }
                    
                    VStack {
                        // SWIFT CODE
                        VStack(alignment: .leading) {
                            Text("Solve this path by Dijksta's Algorithm:")
                                .font(.largeTitle)
                                .padding(.bottom, 20)
                            
                            Image("DijkstraSolve")
                                .resizable()
                                .frame(width: 550, height: 300)
                                .padding(.bottom, 20)
                        }
                        
                        Text("How long will be path to reach node F, starting from A using Dijkstra's Algorithm?")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding([.horizontal])
                        
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
                            Text("Dijkstra's Algorithm")
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
                OverlayDijkstrasAlgo(isVisible: $showOverlay)
                    .animation(.easeInOut, value: showOverlay)
            }
        }
    } //End of body
    
    // MARK: -Checking Guess
    func checkGuess() {
        let playerGuessInt = Int(playerGuess) ?? 0
        
        if 15 == playerGuessInt {
            message = "Congratulations! Head back for next challenge!"
            trigger += 1
            founded = true
            appManager.algoProgress += 10
            appManager.seventhAlgoCompleted = true
        } else {
            message = "Oops! Try again!"
        }
    }
}

// MARK: -Overlay
struct OverlayDijkstrasAlgo: View {
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
                        Text("Dijkstra's Algorithm")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                        Spacer()
                    }
                    Text("""
                        Dijkstra’s Algorithm is a graph-based algorithm used to find the shortest path from a starting node to all other nodes in a weighted graph. It guarantees the shortest distance in graphs with non-negative weights.
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
                        The algorithm begins at a starting node and assigns an initial distance of 0 to it, while all other nodes are set to infinity. It then explores the shortest known path to neighboring nodes, updating their distances. This process repeats until the shortest paths to all nodes are determined.
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
                        Text("Navigation Systems (Google Maps, GPS) to find the shortest route.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Network Routing to determine the fastest data paths.")
                            .font(.title2)
                    }
                    HStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                        Text("Game AI for pathfinding in grid-based games.")
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
extension DijkstrasAlgo {
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
struct DijkstrasAlgoPreview: PreviewProvider {
    static var previews: some View {
        DijkstrasAlgo()
            .environmentObject(AppManager())
    }
}

