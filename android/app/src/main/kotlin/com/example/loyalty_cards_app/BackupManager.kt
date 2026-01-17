package com.example.loyalty_cards_app

import android.app.Activity
import android.content.Intent
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.Scope
import com.google.api.client.extensions.android.http.AndroidHttp
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential
import com.google.api.client.json.gson.GsonFactory
import com.google.api.services.drive.Drive
import com.google.api.services.drive.DriveScopes
import com.google.api.services.drive.model.File as DriveFile
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream

class BackupManager(private val activity: Activity) {
    
    companion object {
        const val REQUEST_SIGN_IN = 1001
        private const val BACKUP_FILE_NAME = "gocards_backup.db"
    }
    
    private var driveService: Drive? = null
    var pendingResult: MethodChannel.Result? = null
    var pendingFilePath: String? = null
    var pendingOperation: String? = null  // "backup", "restore", or "check"
    
    // ========================================
    // PUBLIC API METHODS
    // ========================================
    
    /**
     * Backup database file to Google Drive
     * @param filePath Full path to the database file to backup
     * @param result Flutter method channel result callback
     */
    fun backupDatabase(filePath: String, result: MethodChannel.Result) {
        val account = GoogleSignIn.getLastSignedInAccount(activity)
        val driveScope = Scope(DriveScopes.DRIVE_FILE)

        if (account != null && GoogleSignIn.hasPermissions(account, driveScope)) {
            // Already signed in
            initializeDriveService(account)
            performBackup(filePath, result)
        } else {
            // Need to sign in first
            pendingResult = result
            pendingFilePath = filePath
            pendingOperation = "backup"
            requestSignIn()
        }
    }
    
    /**
     * Restore database file from Google Drive
     * @param result Flutter method channel result callback
     */
    fun restoreDatabase(result: MethodChannel.Result) {
        val account = GoogleSignIn.getLastSignedInAccount(activity)
        val driveScope = Scope(DriveScopes.DRIVE_FILE)
        
        if (account != null && GoogleSignIn.hasPermissions(account, driveScope)) {
            initializeDriveService(account)
            performRestore(result)
        } else {
            pendingResult = result
            pendingOperation = "restore"
            requestSignIn()
        }
    }
    
    /**
     * Check if a backup exists in Google Drive
     * @param result Flutter method channel result callback
     */
    fun checkBackupAvailable(result: MethodChannel. Result) {
        val account = GoogleSignIn.getLastSignedInAccount(activity)
        val driveScope = Scope(DriveScopes.DRIVE_FILE)

        if (account != null && GoogleSignIn.hasPermissions(account, driveScope)) {
            initializeDriveService(account)
            performCheck(result)
        } else {
            // Not signed in = no backup available
            result.success(false)
        }
    }
    
    /**
     * Handle activity result from Google Sign-In
     * Call this from MainActivity. onActivityResult()
     */
    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_SIGN_IN) {
            if (resultCode == Activity.RESULT_OK) {
                try {
                    val task = GoogleSignIn.getSignedInAccountFromIntent(data)
                    val account = task.result
                    val driveScope = Scope(DriveScopes.DRIVE_FILE)

                    if (!GoogleSignIn.hasPermissions(account, driveScope)) {
                         pendingResult?.error("PERMISSION_DENIED", "Google Drive permission was denied by user", null)
                         return
                    }
                    
                    initializeDriveService(account)
                    
                    // Continue with the pending operation
                    when (pendingOperation) {
                        "backup" -> {
                            pendingFilePath?.let { path ->
                                pendingResult?.let { result ->
                                    performBackup(path, result)
                                }
                            }
                        }
                        "restore" -> {
                            pendingResult?.let { result ->
                                performRestore(result)
                            }
                        }
                        "check" -> {
                            pendingResult?.let { result ->
                                performCheck(result)
                            }
                        }
                    }
                } catch (e: Exception) {
                    pendingResult?.error("SIGN_IN_FAILED", e.message, null)
                }
            } else {
                pendingResult?. error("SIGN_IN_CANCELLED", "User cancelled sign-in", null)
            }
            
            // Clear pending operations
            pendingResult = null
            pendingFilePath = null
            pendingOperation = null
        }
    }
    
    // ========================================
    // PRIVATE HELPER METHODS
    // ========================================
    
    /**
     * Request Google Sign-In with Drive permissions
     */
    private fun requestSignIn() {
        val signInOptions = GoogleSignInOptions. Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestEmail()
            .requestScopes(Scope(DriveScopes. DRIVE_FILE))
            .build()
        
        val client = GoogleSignIn.getClient(activity, signInOptions)
        activity.startActivityForResult(client. signInIntent, REQUEST_SIGN_IN)
    }
    
    /**
     * Initialize Google Drive service with authenticated account
     * @param account Signed-in Google account
     */
    fun initializeDriveService(account: GoogleSignInAccount) {
        val credential = GoogleAccountCredential.usingOAuth2(
            activity,
            listOf(DriveScopes. DRIVE_FILE)
        )
        credential.selectedAccount = account.account
        
        driveService = Drive.Builder(
            AndroidHttp.newCompatibleTransport(),
            GsonFactory(),
            credential
        )
            .setApplicationName("GoCards")
            .build()
    }
    
    /**
     * Perform backup operation to Google Drive
     * @param filePath Path to the database file
     * @param result Flutter method channel result
     */
    private fun performBackup(filePath: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val service = driveService 
                    ?: throw Exception("Drive service not initialized")
                
                // Validate source file exists
                val file = File(filePath)
                if (! file.exists()) {
                    throw Exception("Source file not found: $filePath")
                }
                
                // Check if backup file already exists in Google Drive
                val existingFiles = service.files().list()
                    .setQ("name='$BACKUP_FILE_NAME' and trashed=false")
                    . setSpaces("drive")
                    .setFields("files(id, name)")
                    .execute()
                
                // Prepare file metadata
                val fileMetadata = DriveFile().apply {
                    name = BACKUP_FILE_NAME
                }
                
                // Prepare file content
                val mediaContent = com.google.api.client.http.FileContent(
                    "application/octet-stream", 
                    file
                )
                
                // Upload or update file
                if (existingFiles.files.isNotEmpty()) {
                    // Update existing backup
                    val fileId = existingFiles.files[0].id
                    service.files()
                        .update(fileId, fileMetadata, mediaContent)
                        .execute()
                } else {
                    // Create new backup
                    service.files()
                        .create(fileMetadata, mediaContent)
                        .setFields("id")
                        .execute()
                }
                
                // Success! 
                withContext(Dispatchers.Main) {
                    result.success(true)
                }
            } catch (e: Exception) {
                withContext(Dispatchers. Main) {
                    result. error("BACKUP_FAILED", e.message, null)
                }
            }
        }
    }
    
    /**
     * Perform restore operation from Google Drive
     * @param result Flutter method channel result
     */
    private fun performRestore(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val service = driveService 
                    ?: throw Exception("Drive service not initialized")
                
                // Find backup file in Google Drive
                val files = service.files().list()
                    .setQ("name='$BACKUP_FILE_NAME' and trashed=false")
                    .setSpaces("drive")
                    .setFields("files(id, name)")
                    .execute()
                
                if (files.files.isEmpty()) {
                    withContext(Dispatchers.Main) {
                        result.error("NO_BACKUP", "No backup found in Google Drive", null)
                    }
                    return@launch
                }
                
                // Download file to cache directory
                val fileId = files.files[0]. id
                val outputFile = File(activity.cacheDir, "restored_db. db")
                val outputStream = FileOutputStream(outputFile)
                
                service.files()
                    .get(fileId)
                    .executeMediaAndDownloadTo(outputStream)
                
                outputStream.close()
                
                // Return path to restored file
                withContext(Dispatchers.Main) {
                    result.success(outputFile.absolutePath)
                }
            } catch (e: Exception) {
                withContext(Dispatchers. Main) {
                    result. error("RESTORE_FAILED", e.message, null)
                }
            }
        }
    }
    
    /**
     * Check if backup exists in Google Drive
     * @param result Flutter method channel result
     */
    private fun performCheck(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val service = driveService 
                    ?: throw Exception("Drive service not initialized")
                
                val files = service.files().list()
                    .setQ("name='$BACKUP_FILE_NAME' and trashed=false")
                    .setSpaces("drive")
                    .setFields("files(id)")
                    .execute()
                
                withContext(Dispatchers.Main) {
                    result.success(files.files.isNotEmpty())
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.success(false)
                }
            }
        }
    }
}