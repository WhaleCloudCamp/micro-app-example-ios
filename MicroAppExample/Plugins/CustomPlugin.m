//
//  CustomPlugin.m
//  MicroAppExample
//
//  Created by ashoka on 2020/12/22.
//  Copyright © 2020 iWhaleCloud. All rights reserved.
//

#import "CustomPlugin.h"

@implementation CustomPlugin

+ (NSString *)pluginName {
    return @"custom";
}

+ (NSArray *)methodsList {
    return @[@"echo"];
}

- (void)echo:(AlitaCommand *)command {
    id params = command.params;
    NSLog(@"echo: %@", params);
    NSDictionary *result = [AlitaCommandResult resultWithStatus:AlitaCommandStatus_OK message:@"success" responseData:params];
    command.responseCallback(result);
}

@end
