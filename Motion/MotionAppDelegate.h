//
//  MotionAppDelegate.h
//  Motion
//
//  Created by Alasdair Allan on 01/06/2011.
//  Copyright 2011 University of Exeter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MotionViewController;

@interface MotionAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MotionViewController *viewController;

@end
