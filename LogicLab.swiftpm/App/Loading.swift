import SwiftUI
import AVKit

struct LoadePage: View {
    let videoLocalNames = ["LogicLab2"]
    
    @State private var rectangle = false
    
    var body: some View {
        ZStack {
            VStack {
                player(videoName: videoLocalNames[0])
                    .frame(width: 400, height: 400)
            }
            VStack {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 500, height: 500)
                    .opacity((rectangle ? 0 : 1))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.rectangle.toggle()
                }
            }
            
        }
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
    }
}

private struct player : UIViewControllerRepresentable {
    
    var videoName: String = ""
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        let url = Bundle.main.path(forResource: videoName, ofType: ".mp4")!
        let player1 = AVPlayer(url: URL(fileURLWithPath: url))
        controller.player = player1
        player1.play()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<player>) {
        
    }
}
