import SwiftUI
import Foundation

struct Test: View {
    @State private var trigger: Int = 0
    
    var body: some View {
        Button("Click Me") {
            trigger += 1
        }
        .confettiCannon(trigger: $trigger)

    }
}

struct TestPRevie: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
