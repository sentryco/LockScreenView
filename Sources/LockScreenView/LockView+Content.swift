import SwiftUI
import HapticFeedback
/**
 * Content
 */
extension LockView {
   /**
    * Body
    * - Abstract: When authConfig state changes. the view hierarchy changes
    * - Description: This is the main body of the LockScreenView. It contains a ZStack that displays the main content of the application and the cover content based on the authentication state. It also listens for changes in the scenePhase to handle transitions between active, inactive, and background states of the application.
    * - Note: `scenePhase` handles background mode etc
    */
   public var body: some View {
      stack
         .onChange(of: scenePhase) { // detects scene-phase changes
            // Swift.print("onChange: $0: \($0) $1: \($1)")
            onScenePhaseChange($0, $1) // Call handleScenePhaseChange with parameters $0 and $1
         }
   }
   /**
    * Structures the cover-contet above app-content
    * - Fixme: ⚠️️ consider renaming to zStack
    */
   var stack: some View {
      ZStack { // If the view is unlocked, show the content
         content // Show content behind always
         coverContent // - Fixme: ⚠️️ Add doc to this line
      }
   }
   /**
    * Lockview + underlay
    * - Description: This section of the code is responsible for determining the content to
    *                display based on the authentication configuration. It switches between
    *                different views (biometric, pin, or password) to handle user authentication
    *                and secure access to the application.
    * - Fixme: ⚠️️ consider moving the haptic call to didSet in the isLocked var?
    */
   @ViewBuilder
   fileprivate var coverContent: some View {
      // let _ = { Swift.print("isLocked: \(isLocked)") }()
      if isLocked { // If not unlocked, show a biometric unlock view
         underlay // Translucent background
         lockScreen // Show only if locked
      } else { // Grants access to the app after successful authentication. Aka show emptyview
         let _ = { // This called must be wrapped like this because it's not compatible with return type
            HapticFeedback.play(.entry) // Vibrate
         }()
      }
   }
   /**
    * This is the background (translucent)
    * - Description: This is the translucent background that appears when the lock screen
    *                is active. It provides a visual cue to the user that the application
    *                is in a locked state and requires authentication to proceed.
    * - Fixme: ⚠️️ Move underlay into loginview, and animate content etc ? or? remove fixme?
    */
   fileprivate var underlay: some View {
      Rectangle().fill(.clear) // Create a transparent rectangle
         .translucentUnderlay() // Apply translucent underlay effect
   }
}
