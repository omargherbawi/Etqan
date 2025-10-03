import Flutter
import UIKit
import ScreenProtectorKit
import AVFoundation

public class IOSNoScreenshotPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var screenProtectorKit: ScreenProtectorKit? = nil
    private static var methodChannel: FlutterMethodChannel? = nil
    private static var eventChannel: FlutterEventChannel? = nil
    private static var preventScreenShot: Bool = false
    private var eventSink: FlutterEventSink? = nil
    private var lastSharedPreferencesState: String = ""
    private var hasSharedPreferencesChanged: Bool = false

    private static let ENABLESCREENSHOT = false
    private static let DISABLESCREENSHOT = true

    private static let preventScreenShotKey = "preventScreenShot"
    private static let methodChannelName = "com.flutterplaza.no_screenshot_methods"
    private static let eventChannelName = "com.flutterplaza.no_screenshot_streams"
    private static let screenshotPathPlaceholder = "screenshot_path_placeholder"
    private var isMonitoringRecording: Bool = false
    private var recordingMonitorTimer: Timer?

    init(screenProtectorKit: ScreenProtectorKit) {
        self.screenProtectorKit = screenProtectorKit
        super.init()

        let fetchVal = UserDefaults.standard.bool(forKey: IOSNoScreenshotPlugin.preventScreenShotKey)
        updateScreenshotState(isScreenshotBlocked: fetchVal)
        observeScreenRecording()
        handleScreenRecordingChange()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if UIScreen.main.isCaptured {
                self.handleScreenRecordingChange()
            }
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        methodChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: registrar.messenger())
        eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: registrar.messenger())

        let window = UIApplication.shared.delegate?.window
        let screenProtectorKit = ScreenProtectorKit(window: window as? UIWindow)
        screenProtectorKit.configurePreventionScreenshot()

        let instance = IOSNoScreenshotPlugin(screenProtectorKit: screenProtectorKit)
        registrar.addMethodCallDelegate(instance, channel: methodChannel!)
        eventChannel?.setStreamHandler(instance)
        registrar.addApplicationDelegate(instance)
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        persistState()
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        fetchPersistedState()
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        fetchPersistedState()
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        persistState()
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        persistState()
    }

    func persistState() {
        UserDefaults.standard.set(IOSNoScreenshotPlugin.preventScreenShot, forKey: IOSNoScreenshotPlugin.preventScreenShotKey)
        updateSharedPreferencesState("")
    }

    func fetchPersistedState() {
        let fetchVal = UserDefaults.standard.bool(forKey: IOSNoScreenshotPlugin.preventScreenShotKey) ? IOSNoScreenshotPlugin.DISABLESCREENSHOT : IOSNoScreenshotPlugin.ENABLESCREENSHOT
        updateScreenshotState(isScreenshotBlocked: fetchVal)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "screenshotOff":
            shotOff()
            result(true)
        case "screenshotOn":
            shotOn()
            result(true)
        case "toggleScreenshot":
            IOSNoScreenshotPlugin.preventScreenShot ? shotOn() : shotOff()
            result(true)
        case "startScreenshotListening":
            startListening()
            result("Listening started")
        case "stopScreenshotListening":
            stopListening()
            result("Listening stopped")
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func shotOff() {
        IOSNoScreenshotPlugin.preventScreenShot = IOSNoScreenshotPlugin.DISABLESCREENSHOT
        screenProtectorKit?.enabledPreventScreenshot()
        persistState()
    }

    private func shotOn() {
        IOSNoScreenshotPlugin.preventScreenShot = IOSNoScreenshotPlugin.ENABLESCREENSHOT
        screenProtectorKit?.disablePreventScreenshot()
        persistState()
        observeScreenRecording()
        handleScreenRecordingChange()
    }

    private func startListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotDetected), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        persistState()
    }

    private func stopListening() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        persistState()
    }

    @objc private func screenshotDetected() {
        print("Screenshot detected")
        updateSharedPreferencesState(IOSNoScreenshotPlugin.screenshotPathPlaceholder)
    }

    private func updateScreenshotState(isScreenshotBlocked: Bool) {
        if isScreenshotBlocked {
            screenProtectorKit?.enabledPreventScreenshot()
        } else {
            screenProtectorKit?.disablePreventScreenshot()
        }
    }

    private func updateSharedPreferencesState(_ screenshotData: String) {
        let map: [String: Any] = [
            "is_screenshot_on": IOSNoScreenshotPlugin.preventScreenShot,
            "screenshot_path": screenshotData,
            "was_screenshot_taken": !screenshotData.isEmpty
        ]
        let jsonString = convertMapToJsonString(map)
        if lastSharedPreferencesState != jsonString {
            hasSharedPreferencesChanged = true
            lastSharedPreferencesState = jsonString
        }
    }

    private func convertMapToJsonString(_ map: [String: Any]) -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: map, options: .prettyPrinted) {
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        return ""
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.screenshotStream()
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    private func screenshotStream() {
        if hasSharedPreferencesChanged {
            eventSink?(lastSharedPreferencesState)
            hasSharedPreferencesChanged = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.screenshotStream()
        }
    }

    deinit {
        screenProtectorKit?.removeAllObserver()
    }

    private func observeScreenRecording() {
        NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleScreenRecordingChange), name: UIScreen.capturedDidChangeNotification, object: nil)
    }

    @objc private func handleScreenRecordingChange() {
        if UIScreen.main.isCaptured {
            startPersistentMute()
        } else {
            stopPersistentMute()
            unmuteAppAudio()
        }
    }

    private func startPersistentMute() {
        guard !isMonitoringRecording else { return }
        isMonitoringRecording = true
        recordingMonitorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.forceMuteAudio()
        }
        RunLoop.main.add(recordingMonitorTimer!, forMode: .common)
        print("Persistent audio mute started.")
    }

    private func stopPersistentMute() {
        isMonitoringRecording = false
        recordingMonitorTimer?.invalidate()
        recordingMonitorTimer = nil
        print("Persistent audio mute stopped.")
    }

    private func forceMuteAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio muted by switching to .ambient (no output).")
        } catch {
            print("Failed to mute audio: \(error)")
        }
    }

    private func unmuteAppAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio unmuted, playback category restored.")
        } catch {
            print("Failed to unmute audio: \(error)")
        }
    }
}
