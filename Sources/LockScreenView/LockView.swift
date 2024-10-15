import SwiftUI
/**
 * A wrapper for `login-screen` (handles background / foreground phase change etc)
 * - Abstract: A view that displays a login screen with options for entering a master password or using biometric authentication
 * - Description: Add `MainView` to this `LockScreenView` (when app goes to background mode, lock-screen covers main-view etc)
 * - Important: ⚠️️ We keep this in it's own package, so that the autofill extension also can use it, as it can only use code from packages, and not from the app code it self.
 * - Remark: This view is used in the AutoFill-extension and the App
 * - Remark: Initiates session
 * - Remark: Has option to authenticate with `master-password`, `BioAuth` and `pin-code`
 * - Remark: Cover mainview while authenticating user
 * - Note: Has login, overlay, app-content
 * - Note: https://luismdeveloper.com/posts/local-authentication-swiftui/
 * - Note: https://github.com/LuisMDeveloper/local-authentication-swiftUI
 * - Note: We could move it to interface-lib and do authConfig as callback-hocks etc
 * - Fixme: ⚠️️ We should also pass the login-view as a init param, should we? still relevant?
 * - Fixme: ⚠️️ This wrapper doesn't cover pop-over views, do some research around how to solve that, this research is concluded now, we have LockableView now, or we can do this on the UIWindow level, but wait until we have tested LockableView for macOS and iPadOS etc
 * - Fixme: ⚠️️ Replace this with LockableView that supports covering alerts and sheets? that struct uses windows whihch can have sideeffects, yet to be confirmed etc, confirmed
 * - Fixme: ⚠️️ Move to interfacelib, we need these for the AutoFill extension as well 👈
 * - Fixme: ⚠️️ Since this uses authConfig which uses auth we should move it to its own repo 👈
use tupleview?
 */
public struct LockView<Content: View, LockScreen: View>: View {
   /**
    * Content to be displayed when unlocked (The "app-content", "MainView" etc)
    * - Description: This is the main content of the application that will be displayed once
    *                the user has successfully authenticated. It could be any SwiftUI view
    *                that represents the main interface of the application.
    */
   internal let content: Content
   /**
    * Represents the lock-screen view that covers the app-view / content-view
    * - Description: This variable determines which view to show based on the authentication configuration
    * - Fixme: ⚠️️ improve the doc
    */
   internal let lockScreen: LockScreen
   /**
    * Listen for scene change (tracks inactive, active, background)
    * - Description: This callback is responsible for handling changes in the app's scene phase,
    *                such as transitioning between active, inactive, and background states.
    *                It updates the authentication configuration based on the new scene phase
    *                to ensure the app is appropriately locked or unlocked.
    * - Important: ⚠️️ Default closure can't be stored in generic type etc, so we just add it here and in init param
    * - Note: In this closure. The user can add their own AuthConfig enum. Which handles user auth status based on which ever auth the user has enabled. bioauth, pin, password, and other ways
    * - Parameters:
    *   - oldPhase: From this phase
    *   - newPhase: To this phase
    */
   internal var onScenePhaseChange: ScenePhaseChange = { _,_ in Swift.print("default onScenePhaseChange") }
   /**
    * Access the current scene phase / state (background, active, inactive etc)
    * - Description: This environment variable, `scenePhase`, keeps track of the current
    *                state of the app's scene. It can be in one of three states: `active`, `inactive`, or `background`.
    *                This is used to manage the behavior of the app based on its state,
    *                such as locking the screen when the app goes to the background.
    * - Note: Ref: https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-when-your-app-moves-to-the-background-or-foreground-with-scenephase
    * - Note: Apples doc on obfuscating view in switcher mode: https://developer.apple.com/library/archive/qa/qa1838/_index.html
    */
   @Environment(\.scenePhase) internal var scenePhase: ScenePhase
   /**
    * When this state changes. The view structure reacts to the change
    * - Description: State variable also indicate if the view is unlocked or not
    */
   @Binding internal var isLocked: Bool
   /**
    * init
    * - Description: This initializer creates an instance of LockView, which is a wrapper
    *                for the main content of the application. It provides a lock screen
    *                functionality that handles the authentication process and manages
    *                the transitions between different authentication states.
    *                The content to be displayed when the view is unlocked is passed
    *                as a closure parameter to this initializer.
    * - Parameters:
    *   - content: The content to be displayed when the view is unlocked. This can be any SwiftUI view that represents the app's main content.
    *   - lockScreen: The lock screen to be displayed when the view is locked
    *   - isLocked: Bool that determines if the view is locked or not
    *   - onScenePhaseChange: This call back might not be needed as we can use the environment variable to detect when the app goes to the background or foreground in any other place as well
    * - Fixme: ⚠️️ consider calling closure when we use it, in the body etc, do some research on this etc?
    */
   public init(@ViewBuilder content: () -> Content, @ViewBuilder lockScreen: () -> LockScreen, isLocked: Binding<Bool>, onScenePhaseChange: @escaping ScenePhaseChange = { _,_ in Swift.print("default onScenePhaseChange") }) {
      self.content = content()
      self.lockScreen = lockScreen()
      self.onScenePhaseChange = onScenePhaseChange
      self._isLocked = isLocked
   }
}
