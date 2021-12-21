//
//  TimeMusicAppDelegate.h
//  TimeMusic
//
//  Created by 倉富 優 on 11/02/19.
//  Copyright 2011 geo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimeMusicViewController;

@interface TimeMusicAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NSTimer *timer;
    TimeMusicViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TimeMusicViewController *viewController;

@end

