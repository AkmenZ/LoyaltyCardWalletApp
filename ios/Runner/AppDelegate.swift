import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    // Constant for the backup file name
    let BACKUP_FILE_NAME = "gocards_backup.db"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.hyperjam.gocards/backup",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
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
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
        
    // Helper to get the iCloud Documents Directory URL
    private func getiCloudDocumentsURL() -> URL? {
        // nil means "use the default container for this app"
        guard let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) else {
            return nil
        }
        return url.appendingPathComponent("Documents")
    }
    
    private func backupDatabase(call: FlutterMethodCall, result: @escaping FlutterResult) {
        // Run in background to avoid blocking UI
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
                // Create Documents directory if it doesn't exist
                if !fileManager.fileExists(atPath: documentsURL.path) {
                    try fileManager.createDirectory(at: documentsURL, withIntermediateDirectories: true, attributes: nil)
                }
                
                // Remove existing backup if present
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                
                // Copy new file
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
                DispatchQueue.main.async { result(nil) } // No backup found
                return
            }
            
            // IMPORTANT: Trigger download if it's just a placeholder in iCloud
            do {
                try fileManager.startDownloadingUbiquitousItem(at: backupURL)
                
                // Copy to a temp location so Flutter can read it safely
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