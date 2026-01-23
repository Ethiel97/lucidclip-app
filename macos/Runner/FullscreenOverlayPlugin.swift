import Cocoa
import FlutterMacOS

final class FullscreenOverlayPlugin: NSObject, FlutterPlugin {
    // Weak reference to avoid memory leaks
    private weak var window: NSWindow?

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "lucidclip/window_overlay",
            binaryMessenger: registrar.messenger
        )
        let instance = FullscreenOverlayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // More robust window acquisition logic
        let targetWindow = window ?? NSApp.windows.first { $0.canBecomeKey }

        guard let w = targetWindow else {
            result(FlutterError(code: "NO_WINDOW", message: "No suitable NSWindow found", details: nil))
            return
        }

        switch call.method {
        case "setFullscreenOverlay":
            let args = call.arguments as? [String: Any]
            let enabled = (args?["enabled"] as? Bool) ?? true
            setFullscreenOverlay(window: w, enabled: enabled)
            result(nil)

        case "activateApp":
            // NEW: Updated for macOS 14+ / 2026 standards
            NSApp.activate(ignoringOtherApps: true)
            w.makeKeyAndOrderFront(nil)
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func setFullscreenOverlay(window: NSWindow, enabled: Bool) {
        if enabled {
            // These flags allow the window to follow the user into full-screen apps
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            // Use .statusBar to reliably float above all UI elements
            window.level = .statusBar
            window.makeKeyAndOrderFront(nil)
        } else {
            window.collectionBehavior = []
            window.level = .normal
        }
    }
}
