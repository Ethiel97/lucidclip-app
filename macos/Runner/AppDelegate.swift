import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

    override func applicationDidFinishLaunching(_ notification: Notification) {
        GeneratedPluginRegistrant.register(with: self)
        super.applicationDidFinishLaunching(notification)


        // Dans applicationDidFinishLaunching:
        let frontmostChannel = FlutterMethodChannel(
          name: "lucidclip/frontmost_app",
          binaryMessenger: controller.engine.binaryMessenger
        )

        frontmostChannel.setMethodCallHandler { call, result in
          switch call.method {
          case "get":
            let app = NSWorkspace.shared.frontmostApplication
            let bundleId = app?.bundleIdentifier ?? ""
            let name = app?.localizedName ?? ""

            let iconB64: String? = {
              guard let icon = app?.icon else { return nil }
              guard let tiff = icon.tiffRepresentation else { return nil }
              guard let bitmap = NSBitmapImageRep(data: tiff) else { return nil }
              guard let png = bitmap.representation(using: .png, properties: [:]) else { return nil }
              return png.base64EncodedString()
            }()

            result([
              "bundleId": bundleId,
              "name": name,
              "iconPngBase64": iconB64 as Any
            ])

          default:
            result(FlutterMethodNotImplemented)
          }

    }
}
