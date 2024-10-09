import SwiftUI
#if os(iOS)
/**
 * A convenience function that retrieves the key window of the app on iOS devices.
 * - Description: This function can be used to access the key window of the app on iOS devices. For example, you can use it to present a custom alert or to access the root view controller.
 * - Example:
 * ```
 * if let keyWindow = keyWin {
 *     let rootViewController = keyWindow.rootViewController
 *     rootViewController?.present(alertController, animated: true, completion: nil)
 * }
 * ```
 */
internal var keyWin: UIWindow? {
   UIApplication.shared.connectedScenes // Retrieves all connected scenes of the app
      .compactMap { $0 as? UIWindowScene } // Converts each scene to UIWindowScene if possible
      .flatMap { $0.windows } // Flattens the array of windows for each scene into a single array
      .first { $0.isKeyWindow } // Finds the first window that is the key window
}
/**
 * rootController (Better support for SwiftUI) (iOS only)
 * - Abstract: A RootController variable that can be accessed from anywhere
 * - Description: This variable provides a reference to the root view controller of the key window, which can be used for presenting modal view controllers or accessing the current top view controller in the view hierarchy.
 * - Note: Alternative name: `presentedViewController`
 * - Fixme: ⚠️️ seems like this has some issue now, causiing lldb error etc
 *
 * - Example:
 * ```
 * if let rootController = rootController {
 *     let alertController = UIAlertController(title: "Alert", message: "This is an alert", preferredStyle: .alert)
 *     alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
 *     rootController.present(alertController, animated: true, completion: nil)
 * }
 * ```
 * - Returns: The root view controller of the app, which can be used to present alerts or access the root view controller.
 */
internal var rootController: UIViewController? {
   // Retrieve the key window of the app
   let keyWin: UIWindow? = keyWin
   // Initialize the root view controller with the root view controller of the key window
   var root: UIViewController? = keyWin?.rootViewController
   // Loop through the presented view controllers to find the topmost presented view controller
   while let presentedViewController: UIViewController = root?.presentedViewController {
      root = presentedViewController
   }
   // Return the topmost presented view controller
   return root
}
/**
 * Asserts if top view is alert or sheet
 * - Description: This function checks if a modal view, such as an alert or sheet, is currently presented in the app. It is useful for ensuring that the app does not become unresponsive due to multiple modals stacking or for debugging purposes.
 * - Note: Used to avoid locking app if editing something
 * - Note: Thing to print for debugging: `rootController?.sheetPresentationController`, `rootController?.presentedViewController`, `rootController?.presentationController`, `rootController?.view`, `rootController?.presentedViewController`
 * - Note: `isModalInPresentation` is for blocking userinteraction, and not relevant to this
 * - Note: Using NSNotificationCenter https://developer.apple.com/forums/thread/723055
 * - Note: dismissing sheet or alert: UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
 * - Note: Interesting discussion on using environment vars on ispresented etc: https://stackoverflow.com/questions/75353861/dismissing-a-swiftui-sheet-with-a-lot-of-navigation-views
 * - Note: there is also: .fullScreen, .formSheet, .overCurrentContext, .popover
 * - Note: This is global as we parse the window stack
 * - Fixme: ⚠️️ Add macOS support (seems like mac support isn't possible to add), to test this for macOS, we have to run the app. can also be done via the UITestApp xcode proj etc. there is code in UITestApp. But its tricky to test modality. visit this later
 * - Fixme: ⚠️️ Begin by tracing root etc, maybe is NSAlerController NSSheetController etc?
 * - Fixme: ⚠️️⚠️️⚠️️ move this to the LockView package
 */
public var isModalPresented: Bool {
   let presentationStyles: [UIModalPresentationStyle] = [ // popover and sheets
      .pageSheet, // non full cover sheet
      .custom, // alert
      .overFullScreen // full cover sheet
   ]
   guard let rootControllerModalPresentationStyle = rootController?.modalPresentationStyle else {
      return false
   }
   return presentationStyles.contains(rootControllerModalPresentationStyle)
}
#endif
