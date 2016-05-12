//
//  MQTT.m
//  IndoorMap
//
//  Created by Meha Deora on 4/30/16.
//  Copyright © 2016 Estimote, Inc. All rights reserved.
//  Copyright (c) 2014 jmesnil.net. All rights reserved.
//  MODIFIED BY REMOVING THE SWITCH AND PUBLISHING ESTIMOTE COORDINATES INSTEAD OF BOOLEAN VALUE
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MQTT.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIDevice.h>

#import <MQTTKit.h>

#define kMQTTServerHost @"iot.eclipse.org"
#define kTopic @"MQTTEstimote"


@interface MQTT ()

//// this UISwitch will be used to display the status received from the topic.
//@property (weak, nonatomic) IBOutlet UISwitch *subscribedSwitch;

// create a property for the MQTTClient that is used to send and receive the message
@property (nonatomic, strong) MQTTClient *client;

@end

@implementation MQTT

-(void) setUpMQTTserver {
    // create the MQTT client with an unique identifier

    NSString *clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    self.client = [[MQTTClient alloc] initWithClientId:clientID];

//    // keep a reference on the switch to avoid having a reference to self in the
//    // block below (retain/release cycle, blah blah blah)
//    UISwitch *subSwitch = self.subscribedSwitch;
//    
//    // define the handler that will be called when MQTT messages are received by the client
//    [self.client setMessageHandler:^(MQTTMessage *message) {
//        // extract the switch status from the message payload
//        BOOL on = [message.payloadString boolValue];
//        
//        // the MQTTClientDelegate methods are called from a GCD queue.
//        // Any update to the UI must be done on the main queue
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [subSwitch setOn:on animated:YES];
//        });
//    }];
    
    // connect the MQTT client
    [self.client connectToHost:kMQTTServerHost completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            // The client is connected when this completion handler is called
            NSLog(@"client is connected with id %@", clientID);
            // Subscribe to the topic
            [self.client subscribe:kTopic withCompletionHandler:^(NSArray *grantedQos) {
                // The client is effectively subscribed to the topic when this completion handler is called
                NSLog(@"subscribed to topic %@", kTopic);
            }];
        }
    }];

}

-(void)publishToMQTT : (NSDictionary *)position{
    
    
    NSString *payload = [NSString stringWithFormat: @"x: %f, y: %f, orientation: %f",[[position objectForKey:@"xPosition"]floatValue], [[position objectForKey:@"yPosition"]floatValue], [[position objectForKey:@"orinetation"]floatValue]];

    
    // use the MQTT client to send a message with the switch status to the topic
    [self.client publishString:payload
                       toTopic:kTopic
                       withQos:AtMostOnce
                        retain:YES
             completionHandler:nil];
    // we passed nil to the completionHandler as we are not interested to know
    // when the message was effectively sent
}
@end
