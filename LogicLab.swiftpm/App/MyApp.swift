import SwiftUI

@main
struct MyApp: App {
    @State private var showLoadingScreen = true //TODO: True for test/final
    @ObservedObject private var appManager = AppManager.shared
    
    init(){
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if showLoadingScreen {
                    LoadePage()
                    
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.showLoadingScreen = false
                            }
                        }
                }
                MainPage()    //TODO: change to MainPage for test/final
            }
            .navigationViewStyle(.stack)
            .preferredColorScheme(.light)
            .navigationBarHidden(true)
            .environmentObject(AppManager())
        }
    }
}
