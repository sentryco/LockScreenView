import SwiftUI
import HybridColor
/**
 * Preview
 * - Description: This section provides a preview of the LockScreenView.
 *                It wraps the main content of the application in a
 *                LockScreenView and sets the user preferences for the master
 *                password and biometric authentication for testing purposes.
 * - Note: It seems we can't interact with phase-change in preview
 * - Fixme: ⚠️️ also make a Demo authConfig that has psw, granted, bioAuth (that is not implemented out of scope) call it AuthLevel?
 */
#Preview {
   struct ContentView: View {
      /**
       * @State var text: String = "abc123"
       * - Description: The text field for the password.
       */
      @State var text: String = "abc123"
      /**
       * @State var isLocked: Bool = true
       * - Description: Indicates whether the view is currently locked and requires authentication to access.
       */
      @State var isLocked: Bool = true
      /**
       * body
       * - Description: The body of the view.
       */
      var body: some View {
         LockView(
            content: { appView },
            lockScreen: { lockScreen },
            isLocked: $isLocked,
            onScenePhaseChange: handlePhaseChange
         )
      }
      /**
       * appView
       * - Description: The app view.
       */
      var appView: some View {
         let _ = { Swift.print("appView") }()
         return ZStack {
            Rectangle()
               .fill(Color.darkGray.darker(amount: 0.7))
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .edgesIgnoringSafeArea(.all) 
            Text("App content goes here")
         }
      }
      /**
       * lockScreen
       * - Description: The lock screen view.
       */
      var lockScreen: some View {
         let _ = { Swift.print("lockScreen") }()
         return ZStack {
            Rectangle()
               .fill(Color.blackOrWhite)
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .edgesIgnoringSafeArea(.all) // Ignore safe area to cover entire screen if needed
            VStack(spacing: 16){
               Text("Enter password to enter app")
               TextField("Password goes here...", text: $text)
                   .multilineTextAlignment(.center) // center text
                   .padding(.vertical, 6) // Add padding to make the border visible around the text
                   .overlay(
                       RoundedRectangle(cornerRadius: 5) // Adjust corner radius to your preference
                           .stroke(Color.gray, lineWidth: 1) // Set border color and width
                   )
               Button {
                  isLocked = text != "abc123" // unlock if correct
               } label: {
                  Text("OK")
                      .foregroundColor(.white) // Set text color to white
               }
               .padding(.horizontal, 16) // Add padding to increase the tap area and provide space for the background
               .padding(.vertical, 8)
               .background(Color.darkGray) // Set the background color to dark gray
               .cornerRadius(10) // Set the corner radius to make the corners rounded
            }
         }
      }
      /**
       * handlePhaseChange
       * - Description: Handles the phase change of the scene.
       * - Note: This is used to lock the app when the scene is inactive or background.
       */
      func handlePhaseChange(oldPhase: ScenePhase, newPhase: ScenePhase) {
         switch newPhase {
         case .background, .inactive:
            #if os(iOS)
            if isModalPresented { return } // Skip locking app if alert or sheet is active (only for IOS, macOS doesn't have autolock yet)
            #endif
            if oldPhase == .active { // - Fixme: ⚠️️ move into phase, ask copilot
               isLocked = true
            }
         case .active:
            if oldPhase != .active { // - Fixme: ⚠️️ move this into case?, ask copilot
               isLocked = true // lock app if oldPhase was .inactive or .background, and new phase is .active
            } else { Swift.print("⚠️️ This should not happen") }
         @unknown default:
            Swift.print("⚠️️ This can't happen newPhase - @unknown")
         }
      }
   }
   return ContentView()
      .background(Color.blackOrWhite)
      .environment(\.colorScheme, .dark)
}
