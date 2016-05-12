//
//  MQTT.h
//  IndoorMap
//
//  Created by Surabhi Arora on 4/30/16.
//  Copyright © 2016 Estimote, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQTT : NSObject
-(void) setUpMQTTserver ;
-(void)publishToMQTT : (NSDictionary *)position;
@end
