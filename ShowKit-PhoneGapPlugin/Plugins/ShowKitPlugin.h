//
//  ShowKitPlugin.h
//  ShowKit-PhoneGapPlugin
//
//  Created by Yue Chang Hu on 5/3/13.
//
//

#import <Cordova/CDV.h>

static NSString* API_KEY;

@interface ShowKitPlugin : CDVPlugin
@property (strong, nonatomic) UIView *mainVideoUIView;
@property (strong, nonatomic) UIView *prevVideoUIView;
@property (strong, nonatomic) UIView *menuUIView;
@property (strong, nonatomic) UIButton *hangupButton;
@property (strong, nonatomic) UIButton *toggleCameraButton;
@property (strong, nonatomic) UIButton *toggleMuteAudioButton;

- (void)initializeShowKit:(CDVInvokedUrlCommand*)command;
- (void)onResume:(CDVInvokedUrlCommand*)command;
- (void)onPause:(CDVInvokedUrlCommand*)command;
- (void)login:(CDVInvokedUrlCommand*)command;
- (void)initiateCallWithUser:(CDVInvokedUrlCommand*)command;
- (void)registerUser:(CDVInvokedUrlCommand*)command;
- (void)acceptCall:(CDVInvokedUrlCommand*)command;
- (void)rejectCall:(CDVInvokedUrlCommand*)command;
- (void)hangupCall:(CDVInvokedUrlCommand*)command;
- (void)toggleMuteAudio:(CDVInvokedUrlCommand*)command;
- (void)toggleCamera:(CDVInvokedUrlCommand*)command;
- (void)logout:(CDVInvokedUrlCommand*)command;
- (void)setDeviceTorch:(CDVInvokedUrlCommand*)command;
- (void)presentModalViewController:(CDVInvokedUrlCommand*)command;
- (void)setState:(CDVInvokedUrlCommand*)command;
- (void)getState:(CDVInvokedUrlCommand*)command;
- (void)enableConnectionStatusChangedNotification:(CDVInvokedUrlCommand*)command;
- (void)disableConnectionStatusChangedNotification:(CDVInvokedUrlCommand*)command;

@end
