import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    var blurWindow: NSVisualEffectView?
    var recordingCheckTimer: Timer?
    var isAlertVisible = false  // Track alert visibility


  override func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Start a timer to check for recording apps every 2 seconds
        recordingCheckTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkForRecordingApps), userInfo: nil, repeats: true)
  }

  @objc func checkForRecordingApps() {
        let detectedApps = getRunningRecordingApps()
        if !detectedApps.isEmpty {
            applyBlurEffect()               // Apply blur effect over the app
            showRecordingWarningAlert(appNames: detectedApps) // Show warning with detected app names
        } else {
            removeBlurEffect()               // Remove blur effect if no recording apps are detected
        }
  }

  func getRunningRecordingApps() -> [String] {
    let recordingApps = [
        "QuickTime Player", "obs", "OBS Studio", "screencapture", "Loom", "Camtasia", "Snagit",
        "Bandicam", "Fraps", "ScreenFlow", "ShareX", "Dxtory", "Movavi Screen Recorder",
        "Screen Recorder", "ScreenPal", "Apowersoft", "EveryCord", "TechSmith Capture",
        "XRecorder", "AZ Screen Recorder", "Rec. (Screen Recorder)", "Record It!", "Zappy",
        "Screenflick", "Icecream Screen Recorder", "FlashBack Express", "Debut", "ActivePresenter",
        "TinyTake", "ScreenRec", "iShowU", "Capto", "Screenium", "Screenity", "VLC", "Kap",
        "Gifox", "Monosnap", "CloudApp", "Droplr", "Jumpshare", "Screenity", "Peek", "Kazam",
        "SimpleScreenRecorder", "Green Recorder", "VokoscreenNG", "BlueJeans", "GoToMeeting",
        "Cisco Webex", "Skype", "Google Meet", "Slack", "Microsoft Teams", "Zoom", "Discord",
        "TeamViewer", "AnyDesk", "Splashtop", "Chrome Remote Desktop", "Parallels Access",
        "Reflector", "AirServer", "Wirecast", "Streamlabs", "Ecamm Live", "ManyCam", "XSplit",
        "Gamecaster", "Lightstream", "Restream", "vMix", "Livestream Studio", "OBS.Live",
        "Elgato Game Capture", "Camtwist", "Screen Grabber Pro", "ApowerMirror", "Mirroring360",
        "Mirroid", "LetsView", "Mobizen", "DU Recorder", "ScreenCam", "Screen Recorder Pro",
        "Screen Grabber", "Screen Capture", "Screen Recording", "ScreenCast-O-Matic",
        "Screenity", "Screen Recorder HD", "Screen Recorder Lite", "Screen Recorder Studio",
        "Screen Recorder Robot", "Screen Recorder Expert", "Screen Recorder Ultimate",
        "Screen Recorder Plus", "Screen Recorder Free", "Screen Recorder Master",
        "Screen Recorder Professional", "Screen Recorder Deluxe", "Screen Recorder Premium",
        "Screen Recorder Advanced", "Screen Recorder Unlimited", "Screen Recorder Max",
        "Screen Recorder Elite", "Screen Recorder Gold", "Screen Recorder Platinum",
        "Screen Recorder Diamond", "Screen Recorder Pro X", "Screen Recorder Pro Max"
    ]
        let runningApps = NSWorkspace.shared.runningApplications
        var detectedApps: [String] = []
        
        for app in runningApps {
            if let appName = app.localizedName, recordingApps.contains(appName) {
                detectedApps.append(appName)
            }
        }
        
        return detectedApps
  }

  // Adds a blur effect to the entire window to prevent screen recording visibility
  func applyBlurEffect() {
        // Check if blur view already exists to prevent adding multiple layers
        guard blurWindow == nil else { return }
        
        // Create a new blur effect view
        let blurView = NSVisualEffectView()
        blurView.blendingMode = .behindWindow
        blurView.material = .hudWindow
        blurView.state = .active
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the blur view to the main window
        if let mainWindow = NSApp.mainWindow {
            mainWindow.contentView?.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.leadingAnchor.constraint(equalTo: mainWindow.contentView!.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: mainWindow.contentView!.trailingAnchor),
                blurView.topAnchor.constraint(equalTo: mainWindow.contentView!.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: mainWindow.contentView!.bottomAnchor)
            ])
            blurWindow = blurView
        }
  }

  // Removes the blur effect when no recording apps are detected
  func removeBlurEffect() {
        blurWindow?.removeFromSuperview()
        blurWindow = nil
  }

  // Displays a warning alert with the names of detected recording applications
  func showRecordingWarningAlert(appNames: [String]) {
        // Avoid showing multiple alerts if one is already visible
        guard !isAlertVisible else { return }
        isAlertVisible = true  // Set to true to indicate alert is being shown
        
        let alert = NSAlert()
        alert.messageText = "Screen Recording Detected"
        
        // Join the names of detected apps into a single string
        let appList = appNames.joined(separator: ", ")
        alert.informativeText = "Please close the following screen recording applications to use this app: \(appList)"
        
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        
        // Show the alert in the main window and reset visibility on completion
        if let mainWindow = NSApp.mainWindow {
            alert.beginSheetModal(for: mainWindow) { _ in
                self.isAlertVisible = false  // Reset alert visibility once dismissed
            }
        }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
