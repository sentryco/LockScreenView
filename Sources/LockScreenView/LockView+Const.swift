import SwiftUI
/**
 * Const
 */
extension LockView {
   /**
    * ScenePhaseChange: A typealias for a closure that handles changes in the scene phase.
    * - Parameters:
    *   - oldPhase: The previous scene phase.
    *   - newPhase: The new scene phase that the application has transitioned to.
    * - Description: This closure is used to perform actions or update the application state in response to changes in the scene's lifecycle.
    */
   public typealias ScenePhaseChange = (_ oldPhase: ScenePhase, _ newPhase: ScenePhase) -> Void
}
