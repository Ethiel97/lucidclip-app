import Cocoa
import FlutterMacOS
import window_manager
import ApplicationServices


class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)

        RegisterGeneratedPlugins(registry: flutterViewController)

        FullscreenOverlayPlugin.register(with: flutterViewController.registrar(forPlugin: "FullscreenOverlayPlugin"))

        let frontmostChannel = FlutterMethodChannel(
            name: "lucidclip/frontmost_app",
            binaryMessenger: flutterViewController.engine.binaryMessenger
        )

        frontmostChannel.setMethodCallHandler {
            call, result in
            switch call.method {
            case "get":
                let app = NSWorkspace.shared.frontmostApplication
                let bundleId = app?.bundleIdentifier ?? ""
                let name = app?.localizedName ?? ""

                let iconB64: String? = {
                    guard let icon = app?.icon else {
                        return nil
                    }
                    guard let tiff = icon.tiffRepresentation else {
                        return nil
                    }
                    guard let bitmap = NSBitmapImageRep(data: tiff) else {
                        return nil
                    }
                    guard let png = bitmap.representation(using: .png, properties: [:]) else {
                        return nil
                    }
                    return png.base64EncodedString()
                }()

                result([
                    "bundle_id": bundleId,
                    "name": name,
                    "icon": iconB64 as Any
                ])

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        let pasteChannel = FlutterMethodChannel(
            name: "lucidclip/paste_to_app",
            binaryMessenger: flutterViewController.engine.binaryMessenger
        )

        pasteChannel.setMethodCallHandler {
            call, result in
            switch call.method {
            case "checkAccessibilityPermission":
                let trusted = AXIsProcessTrusted()
                result(trusted)
                
            case "requestAccessibilityPermission":
                let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
                let trusted = AXIsProcessTrustedWithOptions(options as CFDictionary)
                result(trusted)
                
            case "pasteToFrontmostApp":
                guard let args = call.arguments as? [String: Any],
                      let bundleId = args["bundleId"] as? String else {
                    result(FlutterError(code: "INVALID_ARGS", 
                                      message: "Missing bundleId", 
                                      details: nil))
                    return
                }
                
                // Check if we have accessibility permission
                let trusted = AXIsProcessTrusted()
                if !trusted {
                    result(FlutterError(code: "NO_PERMISSION", 
                                      message: "Accessibility permission not granted", 
                                      details: nil))
                    return
                }
                
                // Activate the target app
                if let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).first {
                    app.activate(options: .activateIgnoringOtherApps)
                    
                    // Wait a bit for app to activate
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // Simulate Cmd+V paste
                        let source = CGEventSource(stateID: .hidSystemState)
                        
                        // Key down Cmd
                        let cmdDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true)
                        cmdDown?.flags = .maskCommand
                        
                        // Key down V
                        let vDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
                        vDown?.flags = .maskCommand
                        
                        // Key up V
                        let vUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
                        vUp?.flags = .maskCommand
                        
                        // Key up Cmd
                        let cmdUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)
                        
                        // Post events
                        cmdDown?.post(tap: .cghidEventTap)
                        vDown?.post(tap: .cghidEventTap)
                        vUp?.post(tap: .cghidEventTap)
                        cmdUp?.post(tap: .cghidEventTap)
                        
                        result(true)
                    }
                } else {
                    result(FlutterError(code: "APP_NOT_FOUND", 
                                      message: "Target app not running", 
                                      details: nil))
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        super.awakeFromNib()
    }

    override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
        super.order(place, relativeTo: otherWin)
        hiddenWindowAtLaunch()
    }
}
