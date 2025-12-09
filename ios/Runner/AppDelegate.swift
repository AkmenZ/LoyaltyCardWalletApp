import Flutter
import UIKit
import CloudKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller = window?.rootViewController as! FlutterViewController
    setupCloudChannel(controller)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupCloudChannel(_ controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "com.hyperjam.gocards/cloud",
      binaryMessenger: controller.binaryMessenger
    )
    
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "createBackup":
        guard let args = call.arguments as? [String: Any],
              let filePath = args["filePath"] as? String,
              let backupName = args["backupName"] as? String else {
          result(false)
          return
        }
        self.createBackup(filePath: filePath, backupName: backupName) { success in
          result(success)
        }
        
      case "updateBackup":
        guard let args = call.arguments as? [String: Any],
              let filePath = args["filePath"] as? String,
              let backupName = args["backupName"] as? String else {
          result(false)
          return
        }
        self.updateBackup(filePath: filePath, backupName: backupName) { success in
          result(success)
        }
        
      case "deleteBackup":
        guard let args = call.arguments as? [String: Any],
              let backupName = args["backupName"] as? String else {
          result(false)
          return
        }
        self.deleteBackup(backupName: backupName) { success in
          result(success)
        }
        
      case "restoreBackup":
        guard let args = call.arguments as? [String: Any],
              let targetPath = args["targetPath"] as? String,
              let backupName = args["backupName"] as? String else {
          result(nil)
          return
        }
        self.restoreBackup(targetPath: targetPath, backupName: backupName) { path in
          result(path)
        }
        
      case "isCloudAvailable":
        self.isCloudAvailable { available in
          result(available)
        }
        
      case "getBackupInfo":
        guard let args = call.arguments as? [String: Any],
              let backupName = args["backupName"] as? String else {
          result(nil)
          return
        }
        self.getBackupInfo(backupName: backupName) { info in
          result(info)
        }
        
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func createBackup(filePath: String, backupName: String, completion: @escaping (Bool) -> Void) {
    let container = CKContainer.default()
    let database = container.privateCloudDatabase
    
    guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
      completion(false)
      return
    }
    
    let record = CKRecord(recordType: "LoyaltyCardBackup")
    record["backupName"] = backupName
    record["fileData"] = fileData
    record["timestamp"] = Date()
    
    database.save(record) { _, error in
      completion(error == nil)
    }
  }
  
  private func updateBackup(filePath: String, backupName: String, completion: @escaping (Bool) -> Void) {
    let container = CKContainer.default()
    let database = container.privateCloudDatabase
    
    guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
      completion(false)
      return
    }
    
    let predicate = NSPredicate(format: "backupName == %@", backupName)
    let query = CKQuery(recordType: "LoyaltyCardBackup", predicate: predicate)
    
    database.perform(query, inZoneWith: nil) { records, error in
      guard let record = records?.first else {
        self.createBackup(filePath: filePath, backupName: backupName, completion: completion)
        return
      }
      
      record["fileData"] = fileData
      record["timestamp"] = Date()
      
      database.save(record) { _, error in
        completion(error == nil)
      }
    }
  }
  
  private func deleteBackup(backupName: String, completion: @escaping (Bool) -> Void) {
    let container = CKContainer.default()
    let database = container.privateCloudDatabase
    
    let predicate = NSPredicate(format: "backupName == %@", backupName)
    let query = CKQuery(recordType: "LoyaltyCardBackup", predicate: predicate)
    
    database.perform(query, inZoneWith: nil) { records, error in
      guard let record = records?.first else {
        completion(false)
        return
      }
      
      database.delete(withRecordID: record.recordID) { _, error in
        completion(error == nil)
      }
    }
  }
  
  private func restoreBackup(targetPath: String, backupName: String, completion: @escaping (String?) -> Void) {
    let container = CKContainer.default()
    let database = container.privateCloudDatabase
    
    let predicate = NSPredicate(format: "backupName == %@", backupName)
    let query = CKQuery(recordType: "LoyaltyCardBackup", predicate: predicate)
    
    database.perform(query, inZoneWith: nil) { records, error in
      guard let record = records?.first,
            let fileData = record["fileData"] as? Data else {
        completion(nil)
        return
      }
      
      do {
        try fileData.write(to: URL(fileURLWithPath: targetPath))
        completion(targetPath)
      } catch {
        completion(nil)
      }
    }
  }
  
  private func isCloudAvailable(completion: @escaping (Bool) -> Void) {
    let container = CKContainer.default()
    container.accountStatus { status, error in
      completion(status == .available)
    }
  }
  
  private func getBackupInfo(backupName: String, completion: @escaping ([String: Any]?) -> Void) {
    let container = CKContainer.default()
    let database = container.privateCloudDatabase
    
    let predicate = NSPredicate(format: "backupName == %@", backupName)
    let query = CKQuery(recordType: "LoyaltyCardBackup", predicate: predicate)
    
    database.perform(query, inZoneWith: nil) { records, error in
      guard let record = records?.first else {
        completion(nil)
        return
      }
      
      let info: [String: Any] = [
        "backupName": record["backupName"] as? String ?? "",
        "timestamp": record["timestamp"] as? Date ?? Date(),
        "fileSize": (record["fileData"] as? Data)?.count ?? 0
      ]
      
      completion(info)
    }
  }
}
