//
//  radioactivityAppDelegate.h
//  radioactivity
//
//  Created by Selcuk Turhan on 29.06.11.
//  Copyright 2011 own. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMapViewController.h"


@interface radioactivityAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIMapViewController* mapViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIMapViewController* mapViewController;

@end
