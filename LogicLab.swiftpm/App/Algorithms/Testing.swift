import SwiftUI

struct JumpSearchGameView: View {
    @State var numbers = (0..<7).map { _ in Int.random(in: 0...49) }
    @State var targetIndex = Int.random(in: 0...6)
    @State var targetNumber = 0
    @State var playerGuess = ""
    @State var iterations = 0
    @State var message = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Jump Search")
                .onAppear {
                    numbers = bubbleSort(numbers)
                    getTargetNumber()
                    jumpSearch()
                }
            HStack {
                ForEach(numbers.indices, id: \ .self) { index in
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
            Text("How many iterations will be done before Jump search finds number: \(targetNumber)? Don't forget, the first iteration starts from 0.")
                .font(.title)
            
            TextField("Enter your guess", text: $playerGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            Button("Check") {
                checkGuess()
            }
            .buttonStyle(.borderedProminent)
            
            Text(message)
                .foregroundColor(.blue)
                .padding()
        }
        .padding()
    }
    
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

    func checkGuess() {
        let playerGuessInt = Int(playerGuess) ?? 0
        
        if iterations == playerGuessInt {
            message = "Correct"
        }
    }
    
    func jumpSearch() {
        let jump = 2
        let n = numbers.count
        var prev = 0
        iterations = 1
        
        while prev < n && numbers[min(prev + jump, n - 1)] < targetNumber {
            prev += jump
            iterations += 1
        }
        
        for i in prev..<min(prev + jump, n) {
            iterations += 1
            if numbers[i] == targetNumber {
                return
            }
        }
    }
    
    func getTargetNumber() {
        targetNumber = numbers[targetIndex]
    }
}

struct JumpSearchGameView_Previews: PreviewProvider {
    static var previews: some View {
        JumpSearchGameView()
    }
}
