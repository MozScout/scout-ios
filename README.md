# FxListen

[![Build Status](https://travis-ci.org/MozScout/scout-ios.svg?branch=master)](https://travis-ci.org/MozScout/scout-ios)
[![license](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](LICENSE)

*The Firefox Listen mobile app is an iOS app that helps you listen to audio content in a hands-free mode.  The audio content consists of podcasts, web articles, as well as summarizations of web pages.*

## High level  features

 - Listening to web articles and summaries
 - Searching and browsing podcasts
 - Receiving recommendations on content that the user might enjoy based on their interests
 - An engaging first time use (FTU) setup that allows users to provide input for recommendations.
 - Voice Controls (e.g. hands-free mode)
 - Adjustable playback speed

Voice control commands of the app include:

 - Play
 - Pause
 - Volume up
 - Volume up by **number**
 - Volume down
 - Volume down by **number**


## Building

1. Install the latest [Xcode developer tools](https://developer.apple.com/xcode/downloads/) from Apple.

2. Install CocoaPods:

    ```bash
    sudo gem install cocoapods
    ```

3. Clone this git repo somewhere:

    ```bash
    cd <path>
    git clone https://github.com/MozScout/scout-ios
    ```

4. Now, generate the CocoaPods project:

    ```bash
    cd <path>/scout-ios
    pod install
    ```

5. Open the workspace in Xcode:

    ```bash
    open Scout.xcworkspace
    ```
    
6. Build the Scout scheme in Xcode.

## Master Branch

This branch works with Xcode 10.0 and supports iOS 11.0+.

This branch is written in Swift 4.2.

Pull requests should be submitted with master as the base branch and should also be written in Swift 4.2.