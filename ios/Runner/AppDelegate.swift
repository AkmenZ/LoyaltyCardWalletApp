import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    let BACKUP_FILE_NAME = "gocards_backup.db"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Don't access window?.rootViewController here anymore —
        // it may not exist yet under the UIScene lifecycle.
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Called once the Flutter engine + view controller are ready.
    // Register plugins and method channels here instead.
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

        let channel = FlutterMethodChannel(
            name: "com.hyperjam.gocards/backup",
            binaryMessenger: engineBridge.applicationRegistrar.messenger()
        )

        channel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            switch call.method {
            case "backupDatabase":
                self.backupDatabase(call: call, result: result)
            case "restoreDatabase":
                self.restoreDatabase(result: result)
            case "isBackupAvailable":
                self.checkBackup(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    // MARK: - iCloud helpers (unchanged)

    private func getiCloudDocumentsURL() -> URL? {
        guard let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) else {
            return nil
        }
        return url.appendingPathComponent("Documents")
    }

    private func backupDatabase(call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let args = call.arguments as? [String: Any],
                  let sourcePath = args["filePath"] as? String else {
                DispatchQueue.main.async { result(FlutterError(code: "INVALID_ARGS", message: "Path required", details: nil)) }
                return
            }
            guard let documentsURL = self.getiCloudDocumentsURL() else {
                DispatchQueue.main.async { result(FlutterError(code: "ICLOUD_UNAVAILABLE", message: "User is not signed into iCloud", details: nil)) }
                return
            }
            let fileManager = FileManager.default
            let sourceURL = URL(fileURLWithPath: sourcePath)
            let destinationURL = documentsURL.appendingPathComponent(self.BACKUP_FILE_NAME)
            do {
                if !fileManager.fileExists(atPath: documentsURL.path) {
                    try fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true, attributes: nil)
                }
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                DispatchQueue.main.async { result(true) }
            } catch {
                DispatchQueue.main.async { result(FlutterError(code: "BACKUP_FAILED", message: error.localizedDescription, details: nil)) }
            }
        }
    }

    private func restoreDatabase(result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let documentsURL = self.getiCloudDocumentsURL() else {
                DispatchQueue.main.async { result(FlutterError(code: "ICLOUD_UNAVAILABLE", message: "User is not signed into iCloud", details: nil)) }
                return
            }
            let fileManager = FileManager.default
            let backupURL = documentsURL.appendingPathComponent(self.BACKUP_FILE_NAME)
            if !fileManager.fileExists(atPath: backupURL.path) {
                DispatchQueue.main.async { result(nil) }
                return
            }
            do {
                try fileManager.startDownloadingUbiquitousItem(at: backupURL)
                let tempDir = fileManager.temporaryDirectory
                let tempFileUrl = tempDir.appendingPathComponent("restored_temp.db")
                if fileManager.fileExists(atPath: tempFileUrl.path) {
                    try fileManager.removeItem(at: tempFileUrl)
                }
                try fileManager.copyItem(at: backupURL, to: tempFileUrl)
                DispatchQueue.main.async { result(tempFileUrl.path) }
            } catch {
                DispatchQueue.main.async { result(FlutterError(code: "RESTORE_FAILED", message: error.localizedDescription, details: nil)) }
            }
        }
    }

    private func checkBackup(result: @escaping FlutterResult) {
        DispatchQueue.global(qos: .background).async {
            guard let documentsURL = self.getiCloudDocumentsURL() else {
                DispatchQueue.main.async { result(false) }
                return
            }
            let backupURL = documentsURL.appendingPathComponent(self.BACKUP_FILE_NAME)
            let exists = FileManager.default.fileExists(atPath: backupURL.path)
            DispatchQueue.main.async { result(exists) }
        }
    }
}