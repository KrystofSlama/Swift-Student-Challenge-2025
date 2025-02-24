import SwiftUI

struct TerminalAlgo: View {
    @EnvironmentObject var appManager: AppManager
    
    @State var currentMissionControlMessage = ""
    @State var missionControlMessage = ""
    
    @State var currentMissionControlMessageT = ""
    @State var missionControlMessageT = ""
    
    @State private var isWriting = false
    @State private var writeTask: Task<Void, Never>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "apple.terminal.fill")
                    Text("Terminal")
                }
                .fontWeight(.bold)
                .fontDesign(.monospaced) 
                Spacer()
            }
            ScrollView(.vertical, showsIndicators: false) {
                Text(currentMissionControlMessage)
                    .font(.subheadline)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.gray)
                    .onAppear {
                        resetWriter()
                    }
            }
            
            Text("""
            Green - Completed
            Blue - Not Completed
            Red - Locked
            """)
            .font(.subheadline)
            .fontDesign(.monospaced)
            .foregroundStyle(.gray)
        }
        .padding()
        .background(.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onDisappear {
            stopWriter() // Ensure writing stops when the view disappears
        }
    }
    
    func resetWriter() {
        isWriting = false
        currentMissionControlMessage = "" // Clear previous text
        missionControlMessage = appManager.algoFirstMessage
        isWriting = true
        writer()
    }
    
    func stopWriter() {
        isWriting = false
        writeTask?.cancel()
        writeTask = nil
    }
    
    func writer(at position: Int = 0) {
        if !isWriting { return } // Stop writing if reset
        if position < missionControlMessage.count {
            let index = missionControlMessage.index(missionControlMessage.startIndex, offsetBy: position)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                if isWriting { // Ensure writing is still active
                    currentMissionControlMessage.append(missionControlMessage[index])
                    writer(at: position + 1)
                }
            }
        }
    }
}

#Preview {
    TerminalAlgo()
        .environmentObject(AppManager())
}
