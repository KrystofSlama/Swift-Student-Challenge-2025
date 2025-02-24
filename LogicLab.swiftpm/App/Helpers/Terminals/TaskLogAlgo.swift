import SwiftUI

struct TaskLogAlgo: View {
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
            ScrollView(.vertical, showsIndicators: false) {
                Text(currentMissionControlMessage)
                    .font(.subheadline)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.gray)
                    .onAppear{
                        resetWriter()
                    }
            }
            Spacer()
            Text("Completed: \(appManager.algoProgress)%")
                .fontWeight(.bold)
                .fontDesign(.monospaced)
        }
        .padding()
        .background(.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onDisappear() {
            stopWriter()
        }
    }
    
    func resetWriter() {
        isWriting = false
        currentMissionControlMessage = "" // Clear previous text
        if(appManager.firstAlgoCompleted == true && appManager.secondAlgoCompleted == true && appManager.thirdAlgoCompleted == true) {
            missionControlMessage = ""
            missionControlMessage = appManager.taskAlgoFirst
        } else if(appManager.fourthAlgoCompleted == true && appManager.fifthAlgoCompleted == true && appManager.sixthAlgoCompleted == true) {
            missionControlMessage = ""
            missionControlMessage = appManager.taskAlgoSecond
        } else if (appManager.seventhAlgoCompleted == true) {
            missionControlMessage = ""
            missionControlMessage = appManager.taskAlgoThird
        } else {
            missionControlMessage = ""
            missionControlMessage = appManager.taskAlgoZero
        }
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
    TaskLogAlgo()
        .environmentObject(AppManager())
}
