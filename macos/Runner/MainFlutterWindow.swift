import Cocoa
import FlutterMacOS
import window_manager


class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

        let frontmostChannel = FlutterMethodChannel(
          name: "lucidclip/frontmost_app",
          binaryMessenger: flutterViewController.engine.binaryMessenger
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
              "bundle_id": bundleId,
              "name": name,
              "icon": iconB64 as Any
            ])

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
