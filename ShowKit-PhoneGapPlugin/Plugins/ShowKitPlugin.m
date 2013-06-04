//
//  ShowKitPlugin.m
//  ShowKit-PhoneGapPlugin
//
//  Created by Yue Chang Hu on 5/3/13.
//
//

#import "ShowKitPlugin.h"
#import <ShowKit/ShowKit.h>
//#import "ShowKitViewController.h"

@implementation ShowKitPlugin

- (void)initializeShowKit:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    API_KEY = [[NSString alloc] initWithString:(NSString *)[command.arguments objectAtIndex:0]];    
//    SHK_PREFIX = [[NSString alloc] initWithString:(NSString *)[command.arguments objectAtIndex:1]];
    
    [self setupConferenceUIViews];
    
    if (API_KEY != nil) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKConnectionStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStateChanged:) name:SHKConnectionStatusChangedNotification object:nil];
}

- (void)setupConferenceUIViews
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    
    if (self.mainVideoUIView == nil)
    {
        self.mainVideoUIView = [[UIView alloc] initWithFrame: CGRectMake(0,0,screenWidth,screenheight)];
        [self.mainVideoUIView setBackgroundColor:[UIColor blackColor]];
        [self.viewController.view addSubview: self.mainVideoUIView];
        [self.mainVideoUIView setHidden:YES];
        [ShowKit setState:self.mainVideoUIView forKey:SHKMainDisplayViewKey];
    }
    
    if (self.prevVideoUIView == nil)
    {
        self.prevVideoUIView = [[UIView alloc] initWithFrame: CGRectMake(220,20,0.25*screenWidth,0.2*screenheight)];
        [self.viewController.view addSubview: self.prevVideoUIView];
        [self.prevVideoUIView setHidden:YES];
        [ShowKit setState:self.prevVideoUIView forKey:SHKPreviewDisplayViewKey];
    }
    
    if (self.menuUIView == nil)
    {
        self.menuUIView = [[UIView alloc] initWithFrame: CGRectMake(0,screenheight - 66,screenWidth,44)];
        [self.viewController.view addSubview: self.menuUIView];
            
        self.hangupButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [self.hangupButton setTitle:@"End" forState:UIControlStateNormal];
        [self.hangupButton setBackgroundColor:[UIColor redColor]];
        [self.menuUIView addSubview:self.hangupButton];
        
        CGRect bounds = [[self.hangupButton superview] bounds];
        [self.hangupButton setCenter:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))];
        
        self.toggleMuteAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [self.toggleMuteAudioButton setTitle:@"Audio On" forState:UIControlStateNormal];
        [self.toggleMuteAudioButton setBackgroundColor:[UIColor redColor]];
        [self.menuUIView addSubview:self.toggleMuteAudioButton];
        
        self.toggleCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 100, 0, 100, 44)];
        [self.toggleCameraButton setTitle:@"FCamera" forState:UIControlStateNormal];
        [self.toggleCameraButton setBackgroundColor:[UIColor redColor]];
        [self.menuUIView addSubview:self.toggleCameraButton];
        
        
        [self.hangupButton addTarget:self action:@selector(hangupCall:) forControlEvents:UIControlEventTouchUpInside];
        [self.toggleCameraButton addTarget:self action:@selector(toggleCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self.toggleMuteAudioButton addTarget:self action:@selector(toggleMuteAudio:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.menuUIView setHidden:YES];        
    }
    [ShowKit setState:SHKVideoLocalPreviewEnabled forKey:SHKVideoLocalPreviewModeKey];
}

- (void)login:(CDVInvokedUrlCommand*)command
{
   __block CDVPluginResult* pluginResult = nil;

    NSString *username = (NSString *)[command.arguments objectAtIndex:0];    
    NSString *password = (NSString *)[command.arguments objectAtIndex:1];
    
    if (username != nil && password != nil && [username length] > 0 && [password length] > 0) {
//        [ShowKit login:username password:password];
        [ShowKit login:username password:password withCompletionBlock:^(NSString* const connectionStatus) {
            if ([connectionStatus isEqualToString:SHKConnectionStatusLoggedIn]) {
                // Do stuff after successful login.
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"SHKConnectionStatusLoggedIn"];
            } else {
                // The login failed.
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"SHKConnectionStatusLoginFailed"];
            }
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid username or password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
}

- (void)enableConnectionStatusChangedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStateChanged:) name:SHKConnectionStatusChangedNotification object:nil]; 
}

- (void)disableConnectionStatusChangedNotification:(CDVInvokedUrlCommand*)command;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHKConnectionStatusChangedNotification object:nil];
  
}

- (void)initiateCallWithUser:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString *username = (NSString *)[command.arguments objectAtIndex:0];
    
//    username = [NSString stringWithFormat:@"%@.%@", SHK_PREFIX, username];
    
    if (username != nil) {
        [ShowKit setState:self.prevVideoUIView forKey:SHKPreviewDisplayViewKey];

        [self.mainVideoUIView setHidden:NO];
        [self.prevVideoUIView setHidden:NO];
        [self.menuUIView setHidden:NO];
        [ShowKit initiateCallWithUser:username];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hihihi"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)registerUser:(CDVInvokedUrlCommand*)command
{
    NSString *username = (NSString *)[command.arguments objectAtIndex:0];
    
    NSString *password = (NSString *)[command.arguments objectAtIndex:1];
    
    
    if([username length] > 0 && [password length] > 0)
    {
        __block CDVPluginResult* pluginResult = nil;

        [ShowKit registerUser:username
                     password:password
                       apiKey:API_KEY
          withCompletionBlock:^(NSString *username, NSError *error) {
              NSArray *result;
              if(error == nil)
              {
                  result = [NSArray arrayWithObjects:username,[NSNull null],nil];
                  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result];
              }else{
                  result = [NSArray arrayWithObjects:[NSNull null],error.localizedDescription,nil];
                  pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsArray:result];
              }

//              if(error == nil)
//              {
//                  [ShowKit login:username password:password];
//              }else{
//                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                  [alert show];
//                  [alert release];
//              }
              
              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
   
          }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username and password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)acceptCall:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    [ShowKit acceptCall];
    [self.mainVideoUIView setHidden:NO];
    [self.prevVideoUIView setHidden:NO];
    [self.menuUIView setHidden:NO];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hihihi"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)rejectCall:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    
    [ShowKit rejectCall];    
    [self.mainVideoUIView setHidden:YES];
    [self.prevVideoUIView setHidden:YES];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hihihi"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)hangupCall:(CDVInvokedUrlCommand*)command
{
    [ShowKit hangupCall];
    [self.mainVideoUIView setHidden:YES];
    [self.prevVideoUIView setHidden:YES];
    [self.menuUIView setHidden:YES];
}

- (void)logout:(CDVInvokedUrlCommand*)command
{
    [ShowKit logout];
}

- (void)toggleMuteAudio:(CDVInvokedUrlCommand*)command
{    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.curiousminds.showkit_phonegapplugin", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* audio_state = (NSString*)[ShowKit getStateForKey: SHKAudioInputModeKey];
            if([audio_state isEqualToString: SHKAudioInputModeRecording])
            {
                [self.toggleMuteAudioButton setTitle:@"Muted" forState:UIControlStateNormal];
                [ShowKit setState: SHKAudioInputModeMuted forKey: SHKAudioInputModeKey];
            } else {
                [self.toggleMuteAudioButton setTitle:@"Audio On" forState:UIControlStateNormal];
                [ShowKit setState: SHKAudioInputModeRecording forKey: SHKAudioInputModeKey];
            }
        });
    });
}

- (void)toggleCamera:(CDVInvokedUrlCommand*)command
{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.curiousminds.showkit_phonegapplugin", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            id sourceInput = [ShowKit getStateForKey:SHKVideoInputDeviceKey];
            if (sourceInput == SHKVideoInputDeviceBackCamera)
            {
                [self.toggleCameraButton setTitle:@"FCamera" forState:UIControlStateNormal];
                [ShowKit setState: SHKVideoInputDeviceFrontCamera forKey: SHKVideoInputDeviceKey];
            }else{
                [self.toggleCameraButton setTitle:@"BCamera" forState:UIControlStateNormal];
                [ShowKit setState: SHKVideoInputDeviceBackCamera forKey: SHKVideoInputDeviceKey];
            }
        });
    });
}

- (void)setDeviceTorch:(CDVInvokedUrlCommand*)command
{    
    NSString* torchMode = (NSString *)[command.arguments objectAtIndex:0];
    
    if (torchMode != nil)
    {
        if ([torchMode isEqualToString:@"SHKTorchModeOff"]) {
            [ShowKit setState: SHKTorchModeOff forKey: SHKTorchModeKey];  
        }else if([torchMode isEqualToString:@"SHKTorchModeOn"]){
            [ShowKit setState: SHKTorchModeOn forKey: SHKTorchModeKey]; 
        }else if([torchMode isEqualToString:@"SHKTorchModeAuto"]){
            [ShowKit setState: SHKTorchModeAuto forKey: SHKTorchModeKey];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device does not support torch mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

- (void) connectionStateChanged: (NSNotification*) notification
{    
    SHKNotification *showNotice = (SHKNotification*) [notification object];
    NSString *value = (NSString*)showNotice.Value;
    NSError *error = (NSError *)[showNotice UserObject];
    NSString *callee = (NSString *)[showNotice UserObject];
//    callee = [callee stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@.",SHK_PREFIX] withString:@""];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        if ([value isEqualToString:SHKConnectionStatusCallTerminated]){
            [self.mainVideoUIView setHidden:YES];
            [self.prevVideoUIView setHidden:YES];
            [self.menuUIView setHidden:YES];
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL]];
            
        } else if([value isEqualToString:SHKConnectionStatusCallTerminating])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL]];
            
        } else if ([value isEqualToString:SHKConnectionStatusInCall])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL]];
            
        } else if ([value isEqualToString:SHKConnectionStatusLoggedIn])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL]];
            
        } else if ([value isEqualToString:SHKConnectionStatusNotConnected])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%d','%@']))", value,  NULL, NULL, NULL]];
            
        } else if ([value isEqualToString:SHKConnectionStatusLoginFailed])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%d','%@']))", value,  NULL, error.code, error.localizedDescription]];
            
        } else if ([value isEqualToString:SHKConnectionStatusCallIncoming])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, callee, NULL, NULL]];
            
        } else if([value isEqualToString:SHKConnectionStatusCallOutgoing])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%@','%@']))", value, NULL, NULL, NULL]];
            
        } else if([value isEqualToString:SHKConnectionStatusCallFailed])
        {
            
            [self writeJavascript:[NSString stringWithFormat:@"connectionStateChanged(ShowKit.parseConnectionState(['%@','%@','%d','%@']))", value,  NULL, error.code, error.localizedDescription]];
        
        }
        
    }
}

- (void) setState:(CDVInvokedUrlCommand*)command
{
    NSString *key = (NSString *)[command.arguments objectAtIndex:0];
    NSString *value = (NSString *)[command.arguments objectAtIndex:1];
    [ShowKit setState: value forKey: key];
}

- (void) getState:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    NSString *key = (NSString *)[command.arguments objectAtIndex:0];
    NSString *status = [ShowKit getStateForKey:key];
    if(status != NULL)
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:status];
    }else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) presentModalViewController:(CDVInvokedUrlCommand*)command
{
    NSString *nibName = (NSString *)[command.arguments objectAtIndex:0];
    
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nibName bundle:nil];
    
    
//    ShowKitViewController *showkit = [[ShowKitViewController alloc] initWithNibName:nibName bundle:nil];
    [self.viewController presentModalViewController:viewController animated:YES];
}


@end
