# Flutter WebRTC
-keep class org.webrtc.** { *; }

# Socket.IO client
-keep class io.socket.** { *; }
-keep class com.github.nkzawa.** { *; }

# OkHttp (used by socket.io-client)
-dontwarn okhttp3.**
-dontwarn okio.**
