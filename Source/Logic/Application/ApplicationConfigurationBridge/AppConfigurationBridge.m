//
//  AppConfigurationBridge.m
//  Scout
//
//

#import "AppConfigurationBridge.h"

@interface AppConfigurationBridge ()

@property(nonnull, copy) NSString *scoutBaseURL;

@end

@implementation AppConfigurationBridge

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        #ifdef SCOUT_NETWORK_URL
            [self setScoutBaseURL: SCOUT_NETWORK_URL];
        #else
            #error Cant find SCOUT_NETWORK_URL. Please setup xcconfig file
        #endif
    }
    return self;
}

@end
