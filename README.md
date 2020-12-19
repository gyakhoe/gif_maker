# gif_maker

This project will take in vidoe file from gallery and convert them to GIF using FFMEG.
It contains two view screen one for uploading video and converting it to GIF. Other screen
is for displaying all the generated GIFs in GRID view

## Getting Started

## You should know how to setup Flutter app, view the official doc for reference

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### This application/project is built using flutter 1.22.5

## Add dependencies fro selecting video from Gallery in pubspec.yaml file

1. image_picker: ^0.6.7+15
2. video_player: ^1.0.1
3. flutter_ffmpeg: ^0.3.0

# Add config changes to info.plist file

    <key>NSPhotoLibraryUsageDescription</key>
    <string>Access to photos is required </string>
    <key>NSCameraUsageDescription</key>
    <string>Access to camera is required</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Access to microphone is required</string>

    <!-- Video player config starts -->
    <key>NSAppTransportSecurity</key>
    <dict>
    	<key>NSAllowsArbitraryLoads</key>
    	<true/>
    </dict>
    <!-- Video player config ends -->

# Add config changes to AndroidManifest.xml

    <uses-permission android:name="android.permission.INTERNET"/>

## Improvements required

1. Moving from second tab to firt tab, the data in first tab is lost
2. Aspect ratio on grid view could be modifed to acomodate the gif's aspect ratio
3. Tap open the gif and share functionality is required, aslo longpress to share can aslo be added

## References

1. http://ffmpeg.tv
2. https://fireship.io/lessons/wasm-video-to-gif/
3. https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
