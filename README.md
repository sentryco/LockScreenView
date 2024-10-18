[![Tests](https://github.com/sentryco/LockScreenView/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/LockScreenView/actions/workflows/Tests.yml)

# LockScreenView

> Add lockability to your app

## Features

- Add your own "lock-UI"
- Add your own "authentication-handler"
- Avoids locking the app if there are active alerts or sheets (iOS only, because alerts and sheets are above the app views, and as such cant be locked, unless dismissed, which can result in data loss)
- Designed entirely with SwiftUI, ensuring smooth integration with modern iOS and macOS applications.
- Automatically manages app locking and unlocking based on the app's lifecycle events
- Has translucent overlay bellow lockview as standard

## Example

- This example demonstrates how to integrate the `LockScreenView` into your SwiftUI application. It shows a basic setup where the lock screen is presented based on the app's authentication state.
- This example provides a clear and concise demonstration of how to use the `LockScreenView` in a SwiftUI application, including a basic lock screen setup. Adjust the example as necessary to fit the specific functionalities and design of your application.

```swift
import SwiftUI
import LockScreenView

struct ContentView: View {
   @State private var isLocked = true
   var body: some View {
      LockView(
         content: { MainView() },
         lockScreen: { LockScreen() },
         isLocked: $isLocked
      )
   }
}
struct MainView: View {
   var body: some View {
      Text("Main App Content")
   }
}
struct LockScreen: View {
   @State private var password: String = "abc123"
   @State var isLocked: Bool = true
   var body: some View {
      VStack(spacing: 20) {
         Text("Enter your password")
         SecureField("Password", text: $password)
            .padding()
            .background(Color.secondary.opacity(0.3))
            .cornerRadius(5)
         Button("Unlock") {
            isLocked = text != "abc123"
         }
         .padding()
         .background(Color.blue)
         .foregroundColor(.white)
         .cornerRadius(10)
      }
      .padding()
      .background(Color.gray.opacity(0.2))
      .cornerRadius(15)
   }
}
```

## Aditional example:

Add a container wrapper to contain the state and add more functionality like 

```swift
// fix: add AuthConfig enum to this example
struct LockViewModifier: ViewModifier {
    /** 
     * Indicates whether the view is currently locked and requires authentication to access. 
     */
    @State private var isLocked: Bool = true
    /** 
     * Returns a view that conditionally shows a lock screen based on the `isLocked` state.
     * - Parameter content: The main content of the application.
     * - Returns: A view that either shows the lock screen or the main content based on the authentication state.
     */
    func body(content: Content) -> some View {
         let lockView = LockView(content: { content }, lockScreen: { lockScreen }, isLocked: isLocked, onPhaseChange: handlePhaseChange)
        
    }
    // fix: add lock UI here
    var lockScreen: some View {
        EmptyView()
    }
    /** 
     * Handles the phase change event.
     * - Parameters:
     *   - oldPhase: The old scene phase.
     *   - newPhase: The new scene phase.
     */
    fileprivate func handlePhaseChange(oldPhase: ScenePhase, newPhase: ScenePhase) {
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

extension View {
    /**
     * Wraps the `LockViewModifier` around the calling view.
     *
     * This method extends any SwiftUI view to include lock screen functionality by applying the `LockViewModifier`.
     * When invoked, it conditionally overlays a lock screen over the content based on the authentication state managed by `isLocked`.
     *
     * Usage:
     * ```
     * Text("Hello, World!").lockView()
     * ```
     *
     * - Returns: A view modified by `LockViewModifier`, which conditionally displays a lock screen.
     */
    func lockView() -> some View {
        self.modifier(LockViewModifier())
    }
}
```

## Dependencies

- [https://github.com/sentryco/HybridColor](https://github.com/sentryco/HybridColor): A library for handling color transformations and compatibility across different platforms.
- [https://github.com/sentryco/BlurView](https://github.com/sentryco/BlurView): Provides a SwiftUI view that applies a blur effect to the background content.
- [https://github.com/sentryco/HapticFeedback](https://github.com/sentryco/HapticFeedback): Allows for easy integration of haptic feedback within iOS applications.

## Installation

Swift Package Manager:
```
.package(url: "https://github.com/sentryco/LockScreenView", branch: "main")
```

## Todo:
- Improve the readme 
- Add the improved example code 
- Add doc regarding why it's hard to detect alerts and sheets for macOS
- There might be a way to detect alerts and sheets for macOS, more thinking / exploration / research needed