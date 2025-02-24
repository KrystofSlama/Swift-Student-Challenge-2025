import SwiftUI

struct TaskLog: View {
    @EnvironmentObject var appManager: AppManager
    
    @State var currentMissionControlMessage = ""
    @State var missionControlMessage = ""
    
    @State private var isWriting = false
    @State private var writeTask: Task<Void, Never>?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "apple.terminal.fill")
                    Text("Task Log")
                }
                .fontWeight(.bold)
                .fontDesign(.monospaced)
                
                Spacer()
            }
            
            Text(currentMissionControlMessage)
                .font(.subheadline)
                .fontDesign(.monospaced)
                .foregroundStyle(.gray)
                .onAppear{
                    resetWriter()
                }
            Spacer()
        }
        .padding()
        .background(.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onDisappear {
            stopWriter()
        }
    }
    
    func resetWriter() {
        isWriting = false
        currentMissionControlMessage = "" // Clear previous text
        missionControlMessage = appManager.taskMessage
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
    TaskLog()
        .environmentObject(AppManager())
}
