# roomba-estimotes-localization

roomba-estimotes-localization is an iOS application for publishing [Estimote][estimotes] indoor location to a [Create 2 obstacle mapper][mapper] via [MQTT][mqtt]. Only tested on iPhone 5s, 6s, iOS 9.3.1.

It uses Estimote's [Indoor Location SDK][sdk] for getting the iPhone's indoor location and jmesnil's [MQTTKit][mqttkit] for running an MQTT client on iOS.

It requires 4+ [Estimote beacons][beacons] and an [Estimote Cloud account][cloud].

This app was used as a supplement to the [Create 2 obstacle mapping project][mapper], but can easily be applied to a different project so long as you implement your own MQTT subscriber.

## Installation Using CocoaPods

Open Terminal, navigate to this directory. 
For the first time, run:
```
$ pod install
```

For updating the project, run:
```
$ pod update
```

We suggest editing the project using XCode 7.3+. Open the `IndoorMap.xcworkspace` and edit away!

## App Setup
Change the app to connect to your [Estimote Cloud account][cloud]. Open `ViewController.swift` and change the `App ID`, `App Token`, and `Location Identifier` appropriately.

You can change the MQTT publish topic to something more unique. Open `MQTT.m` and change the `kTopic` variable to any string of your liking. 

Then plug in your iPhone to the computer via USB. In XCode, change your build target to your iPhone, and build.

## Room Setup
On your iPhone, search the App Store for the `Estimote Indoor Location` app. Install and run the app, and follow the step by step instructions for placing and configuring your beacons.

## Usage

Start your IndoorMap iOS app on your phone. Walk around the room and make sure you see the person moving around with you in the GUI.

Then make sure the app is properly publishing. One way to do this is by running the MQTT subscriber provided in the accompanying [Create 2 obstacle mapping project][mapper].

## Authors

* Aashiq Ahmed (aashiqah@usc.edu)
* Shuai Chen (shuaic@usc.edu)
* Meha Deora (mdeora@usc.edu)
* Douglas Hu (douglamh@usc.edu)

[estimotes]: http://estimote.com/
[mapper]: https://github.com/DougMHu/roomba-obstacle-mapping
[mqtt]: http://public.dhe.ibm.com/software/dw/webservices/ws-mqtt/mqtt-v3r1.html
[sdk]: https://github.com/Estimote/iOS-Indoor-SDK
[mqttkit]: https://github.com/jmesnil/MQTTKit
[cloud]: https://cloud.estimote.com/#/login
[beacons]: http://estimote.com/#jump-to-products
