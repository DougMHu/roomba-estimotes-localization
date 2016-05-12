//
//  ViewController.swift
//  IndoorMap
//

import UIKit


class ViewController: UIViewController, EILIndoorLocationManagerDelegate {

    let locationManager = EILIndoorLocationManager()
    let instanceOfMqtt = MQTT()
    
    var location: EILLocation!
    
    

    @IBOutlet weak var locationView: EILIndoorLocationView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let instanceOfMqtt: MQTT = MQTT()
        instanceOfMqtt.setUpMQTTserver()
        
        // TODO : put your App ID and App Token here
        // You can get them by adding your app on https://cloud.estimote.com/#/apps
        ESTConfig.setupAppID("mdeora-usc-edu-s-your-own--jvi", andAppToken: "f00aa8932d0603a602f8dd9e997ed0b4")

        self.locationManager.delegate = self

        // TODO : replace with an identifier of your own location
        // You will find the identifier on https://cloud.estimote.com/#/locations
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "doug-s-apt")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if let location = location {
                self.location = location

                // You can configure the location view to your liking:
                self.locationView.showTrace = true
                self.locationView.rotateOnPositionUpdate = false
                // Consult the full list of properties on:
                // http://estimote.github.io/iOS-Indoor-SDK/Classes/EILIndoorLocationView.html

                self.locationView.drawLocation(location)
                self.locationManager.startPositionUpdatesForLocation(self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
    }

    func indoorLocationManager(manager: EILIndoorLocationManager, didFailToUpdatePositionWithError error: NSError) {
        print("failed to update position: \(error)")
    }

    func indoorLocationManager(manager: EILIndoorLocationManager, didUpdatePosition position: EILOrientedPoint, withAccuracy positionAccuracy: EILPositionAccuracy, inLocation location: EILLocation) {
        var accuracy: String!
        switch positionAccuracy {
        case .VeryHigh: accuracy = "+/- 1.00m"
        case .High:     accuracy = "+/- 1.62m"
        case .Medium:   accuracy = "+/- 2.62m"
        case .Low:      accuracy = "+/- 4.24m"
        case .VeryLow:  accuracy = "+/- ? :-("
        case .Unknown:  accuracy = "unknown"
        }
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@", position.x, position.y, position.orientation, accuracy))

        self.locationView.updatePosition(position)
        
        let positionsDictionary: [String:Double] = [
            "xPosition" : position.x,
            "yPosition" : position.y,
            "orinetation" : position.orientation
        ]
        instanceOfMqtt.publishToMQTT(positionsDictionary)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
