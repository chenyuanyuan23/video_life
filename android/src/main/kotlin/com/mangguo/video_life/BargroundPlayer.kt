package com.mangguo.video_life

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class BargroundPlayer : Service() {
    //将服务置于启动状态 ,NOTIFICATION_ID指的是创建的通知的ID
    private val NOTIFICATION_ID = 1002
    
    companion object {
        private const val TAG = "BargroundPlayer"
        @Volatile
        private var isServiceRunning: Boolean = false
        private val serviceLock = Any()

        fun start(context: Context) {
            synchronized(serviceLock) {
                if (isServiceRunning) {
                    Log.d(TAG, "Service already running, skipping start")
                    return
                }
                
                Log.d(TAG, "Starting foreground service")
                val starter = Intent(context, BargroundPlayer::class.java)
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        context.startForegroundService(starter)
                    } else {
                        context.startService(starter)
                    }
                    isServiceRunning = true
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to start service", e)
                    isServiceRunning = false
                }
            }
        }

        fun stop(context: Context) {
            synchronized(serviceLock) {
                if (!isServiceRunning) {
                    Log.d(TAG, "Service not running, skipping stop")
                    return
                }
                
                Log.d(TAG, "Stopping foreground service")
                val intent = Intent(context, BargroundPlayer::class.java)
                try {
                    context.stopService(intent)
                } finally {
                    isServiceRunning = false
                }
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service onCreate()")
        // 确保立即调用 startForeground
        try {
            val notification: Notification = createForegroundNotification()
            startForeground(NOTIFICATION_ID, notification)
            Log.d(TAG, "startForeground() called successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start foreground", e)
            // 如果失败，立即停止服务避免崩溃
            stopSelf()
        }
    }

    private fun createForegroundNotification(): Notification {
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        // 唯一的通知通道的id.
        val notificationChannelId = "notification_channel_id_02"
        // Android8.0以上的系统，新建消息通道
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //用户可见的通道名称
            val channelName = "后台运行"
            //通道的重要程度
            val importance = NotificationManager.IMPORTANCE_LOW
            val notificationChannel = NotificationChannel(
                notificationChannelId, channelName, importance
            )
            notificationChannel.description = "应用切到后台保持运行"
            notificationChannel.enableVibration(false)
            notificationChannel.enableLights(false)
            notificationChannel.setSound(null, null)
            notificationManager.createNotificationChannel(notificationChannel)
        }

        val builder = NotificationCompat.Builder(this, notificationChannelId)
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle("后台运行中")
            .setContentText("点击返回应用")
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setAutoCancel(true)
            .setStyle(NotificationCompat.BigTextStyle().bigText("点击返回应用"))
            .setOngoing(true)
        // 获取应用程序的包名
        val packageName = getPackageName()
        // 获取应用程序的启动器Activity的Intent
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        if (intent != null) {
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            val pendingIntent =
                PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            builder.setContentIntent(pendingIntent)
        }

        //创建通知并返回
        return builder.build()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service onStartCommand()")
        
        // 确保即使是重复启动也调用 startForeground，避免 RemoteServiceException
        try {
            val notification: Notification = createForegroundNotification()
            startForeground(NOTIFICATION_ID, notification)
            Log.d(TAG, "startForeground() called in onStartCommand()")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start foreground in onStartCommand", e)
            stopSelf()
        }
        
        // 返回 START_NOT_STICKY 表示如果服务被杀死，不要重启
        return START_NOT_STICKY
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        Log.d(TAG, "Service onDestroy()")
        super.onDestroy()
        
        synchronized(serviceLock) {
            isServiceRunning = false
        }
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.d(TAG, "Service onTaskRemoved()")
        super.onTaskRemoved(rootIntent)
        stopSelf()
    }
}