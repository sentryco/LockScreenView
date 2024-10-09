[![Tests](https://github.com/sentryco/LockScreenView/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/LockScreenView/actions/workflows/Tests.yml)

# LockScreenView

> Add lockability to your app

## Description 

Add security measures to your app. Easily integrate Biometric auth / Password and Pin code. 

## Features

- Add your own lock UI 
- Add your own authentication handler 
- Avoids locking the app if there are active alerts or sheets (iOS only, because alerts and sheets are above the app views, and as such cant be locker, unless dismissed, which can result in data loss)
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

## Dependencies

- [https://github.com/sentryco/HybridColor](https://github.com/sentryco/HybridColor): A library for handling color transformations and compatibility across different platforms.
- [https://github.com/sentryco/BlurView](https://github.com/sentryco/BlurView): Provides a SwiftUI view that applies a blur effect to the background content.
- [https://github.com/sentryco/HapticFeedback](https://github.com/sentryco/HapticFeedback): Allows for easy integration of haptic feedback within iOS applications.

## Installation

Swift Package Manager:
```
.package(url: "https://github.com/sentryco/LockScreenViev", branch: "main")
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
