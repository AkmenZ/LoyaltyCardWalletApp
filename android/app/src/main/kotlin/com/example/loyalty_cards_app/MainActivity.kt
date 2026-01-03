package com.example.loyalty_cards_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity:  FlutterActivity() {
    private val CHANNEL = "com.hyperjam.gocards/backup"
    private lateinit var backupManager: BackupManager
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize backup manager
        backupManager = BackupManager(this)
        
        // Set up method channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, 
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "backupDatabase" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        backupManager.backupDatabase(filePath, result)
                    } else {
                        result.error("INVALID_ARGS", "File path is required", null)
                    }
                }
                "restoreDatabase" -> {
                    backupManager. restoreDatabase(result)
                }
                "isBackupAvailable" -> {
                    backupManager.checkBackupAvailable(result)
                }
                else -> {
                    result. notImplemented()
                }
            }
        }
    }
    
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        backupManager.handleActivityResult(requestCode, resultCode, data)
    }
}
