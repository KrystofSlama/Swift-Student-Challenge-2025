import SwiftUI
import Foundation

class AppManager: ObservableObject {
    static let shared = AppManager()
    
    @Published var wwdcModeBool = false // Change this to unlock everything
    // Algorithms setting
    @Published var lockedAlgo = [0: false, 1: true, 2: true, 3: false, 4: true, 5: true, 6: false]
    @Published var allAlgoCompleted = false
    @Published var algoProgress = 0
            
    @Published var firstAlgoCompleted = false
    @Published var secondAlgoCompleted = false
    @Published var thirdAlgoCompleted = false
    @Published var fourthAlgoCompleted = false
    @Published var fifthAlgoCompleted = false
    @Published var sixthAlgoCompleted = false
    @Published var seventhAlgoCompleted = false
    //---------------------------------
    
    
    // Main Page Terminal
    @Published var welcomeMessage = 
    """
    Welcome to LogicLab!

    Dive into the world of algorithms and discover the fundamentals of Computer Science. Here, you'll explore essential searching, sorting, and other key algorithms through interactive learning.

    Start by understanding how algorithms work step by step and build a strong foundation in problem-solving. Let’s begin!
    """
    
    // Task log Main Page
    @Published var taskMessage = 
    """
    Start with algorithms.
    New challanges coming soon!!!
    
    
    WWDC Mode - After clicking WWDC Mode button, everything is going to be unlocked. After clicking it again, everything is going to be reseted.
    """
    //---------------------------------
    
    // Algorithms Text
    @Published var algoFirstMessage = 
    """
    Algorithms are the backbone of problem-solving in Computer Science, helping us efficiently organize and search through data. 
    
    In this section, you'll explore fundamental techniques, starting with sorting algorithms like Bubble Sort, Insertion Sort, and Selection Sort, which arrange data step by step based on comparisons. 
    
    You'll also dive into searching algorithms, including Linear Search, Binary Search, and Jump Search, which help locate data efficiently in different scenarios. 
    
    Finally, you'll uncover Dijkstra’s Algorithm, a powerful pathfinding method used to determine the shortest route in graphs, crucial for navigation and networking. 
    
    Through interactive learning, you'll see how these algorithms work in action and understand their importance in real-world applications.
    """
    
    // Task log Algo
    @Published var taskAlgoZero = 
    """
    Completed
      Sorting Algorithms - Not Completed
      Searching Algorithms - Not Completed
      Other Algorithms - Not Completed
    """
    
    @Published var taskAlgoFirst = 
    """
    Completed
        Sorting Algorithms - Completed
        Searching Algorithms - Not Completed
        Other Algorithms - Not Completed
    """
    
    @Published var taskAlgoSecond =
    """
    Completed
        Sorting Algorithms - Completed
        Searching Algorithms - Completed
        Other Algorithms - Not Completed
    """
    
    @Published var taskAlgoThird =
    """
    Completed
        Sorting Algorithms - Completed
        Searching Algorithms - Completed
        Other Algorithms - Completed
    """
    //---------------------------------
    
    
    
    
    
    
    //---------------------------------
}

