//
//  MotionViewController.m
//  Motion
//
//  Created by Alasdair Allan on 01/06/2011.
//  Copyright 2011 University of Exeter. All rights reserved.
//

#import "MotionViewController.h"

float rotX = 0.00f, oldX = 0.00f, rotY = 0.00f, rotZ = 0.00f;
float oldZ = 0.00f, oldY = 0.00f, jumrotX = 0.00f , jumoldX = 0.00f;
int stateID = 0;
int flag = 1;
char *stateIDstr = "---Stop---";
char *stateIDstr2 = "STOP";


int indexLoop = 0,indexLoop2 = 0;

@implementation MotionViewController

- (void)accelerometer:(UIAccelerometer *)meter  didAccelerate:(UIAcceleration *)acceleration {
    rawAccelLabelX.text = [NSString stringWithFormat:@"%2.2f", acceleration.x];
    rawAccelIndicatorX.progress = ABS(acceleration.x);
    
    rawAccelLabelY.text = [NSString stringWithFormat:@"%2.2f", acceleration.y];
    rawAccelIndicatorY.progress = ABS(acceleration.y);
    
    rawAccelLabelZ.text = [NSString stringWithFormat:@"%2.2f", acceleration.z];
    rawAccelIndicatorZ.progress = ABS(acceleration.z);  
}

- (void) updateView:(NSTimer *)timer  {
    
    CMDeviceMotion *motionData = motionManager.deviceMotion;
    
    CMAttitude *attitude = motionData.attitude;
    CMAcceleration gravity = motionData.gravity;
    CMAcceleration userAcceleration = motionData.userAcceleration;
    CMRotationRate rotate = motionData.rotationRate;
 
    
    yawLabel.text = [NSString stringWithFormat:@"%2.2f", attitude.yaw];
    pitchLabel.text = [NSString stringWithFormat:@"%2.2f", attitude.pitch];
    rollLabel.text = [NSString stringWithFormat:@"%2.2f", attitude.roll];
    
    accelIndicatorX.progress = ABS(userAcceleration.x);
    accelIndicatorY.progress = ABS(userAcceleration.y);
    accelIndicatorZ.progress = ABS(userAcceleration.z);
    accelLabelX.text = [NSString stringWithFormat:@"%2.2f",userAcceleration.x];
    accelLabelY.text = [NSString stringWithFormat:@"%2.2f",userAcceleration.y];
    accelLabelZ.text = [NSString stringWithFormat:@"%2.2f",userAcceleration.z];
    
    gravityIndicatorX.progress = ABS(gravity.x);
    gravityIndicatorY.progress = ABS(gravity.y);
    gravityIndicatorZ.progress = ABS(gravity.z);
    gravityLabelX.text = [NSString stringWithFormat:@"%2.2f",gravity.x];
    gravityLabelY.text = [NSString stringWithFormat:@"%2.2f",gravity.y];
    gravityLabelZ.text = [NSString stringWithFormat:@"%2.2f",gravity.z];
    
    rotIndicatorX.progress = ABS(rotate.x);
    rotIndicatorY.progress = ABS(rotate.y);
    rotIndicatorZ.progress = ABS(rotate.z);
    
    rotasiX.text = [NSString stringWithFormat:@"%2.2f",rotate.x];
    rotasiY.text = [NSString stringWithFormat:@"%2.2f",rotate.y];
    rotasiZ.text = [NSString stringWithFormat:@"%2.2f",rotate.z];
    
    rotX += ABS(rotate.x-oldX)*10;
    rotZ += ABS(rotate.z-oldZ)*10;
    rotY += ABS(rotate.y-oldY)*10;
    jumrotX += (userAcceleration.z-jumoldX)*10;
    
    
    
        
    indexLoop += 1;
        
    if (indexLoop==3) // 6
    {
        float totXYZ = rotX+rotZ+rotY;
        
        indexLoop2 += 1;
        
        if (totXYZ>47)
        {
            
            stateID = 2;
            stateIDstr = "--Rotate--";
            indexLoop2 = 0;
        }
        else if (totXYZ>14)
        {
            if (jumrotX < 0.1) {
                if (flag == 1) {
                    stateID = 1;
                    flag = 2;
                }
            }else{
                if (flag == 1) {
                    stateID = 1;
                    flag = 3;
                }
            }
            
            stateIDstr = "--Walking--";

        }
        else
        {
            stateID = 0;
             stateIDstr = "---Stop---";
            flag = 1;
            jumoldX = 0.00f;
        }
        
        NSLog(@"%f",jumrotX);
        
        total.text = [NSString stringWithFormat:@"%2.2f",jumrotX];
            
        rotX = 0.0;
        rotZ = 0.0;
        rotY = 0.0;
        indexLoop = 0;
        
    }
    
    
    if ((stateID<=1) && (flag==2))
    {
        stateIDstr2 = "Maju";

    }
    else if((stateID<=1) && (flag==3))
    {
        stateIDstr2 = "Mundur";
    }else{
        stateIDstr2 = "";
    }
    
    oldX = rotate.x;
    oldY = rotate.y;
    oldZ = rotate.z;
    
    jumoldX = userAcceleration.z;

    
    rotState.text = [NSString stringWithFormat:@"%s",stateIDstr];
    stateidr2.text = [NSString stringWithFormat:@"%s",stateIDstr2];
    
    rotLabelX.text = [NSString stringWithFormat:@"%2.2f",rotX];
    rotLabelY.text = [NSString stringWithFormat:@"%2.2f",rotY];
    rotLabelZ.text = [NSString stringWithFormat:@"%2.2f",rotZ];
    
}

- (void)dealloc {
    [yawLabel release];
    [pitchLabel release];
    [rollLabel release];
    [accelIndicatorX release];
    [accelIndicatorY release];
    [accelIndicatorZ release];
    [accelLabelX release];
    [accelLabelY release];
    [accelLabelZ release];
    [gravityIndicatorX release];
    [gravityIndicatorY release];
    [gravityIndicatorZ release];
    [gravityLabelX release];
    [gravityLabelY release];
    [gravityLabelZ release];
    [rotIndicatorX release];
    [rotIndicatorY release];
    [rotIndicatorZ release];
    [rotLabelX release];
    [rotLabelY release];
    [rotLabelZ release];
    [rotState release];
    [rawAccelIndicatorX release];
    [rawAccelIndicatorY release];
    [rawAccelIndicatorZ release];
    [rawAccelLabelX release];
    [rawAccelLabelY release];
    [rawAccelLabelZ release];
    [stateidr2 release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval =  1.0 / 30.0;
    [motionManager startDeviceMotionUpdates];
    if (motionManager.deviceMotionAvailable ) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
    } else {
        [motionManager stopDeviceMotionUpdates];
        [motionManager release];
    }
    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 0.1f;
    accelerometer.delegate = self;
    

    
}

- (void)viewDidUnload {
    [yawLabel release];
    yawLabel = nil;
    [pitchLabel release];
    pitchLabel = nil;
    [rollLabel release];
    rollLabel = nil;
    [accelIndicatorX release];
    accelIndicatorX = nil;
    [accelIndicatorY release];
    accelIndicatorY = nil;
    [accelIndicatorZ release];
    accelIndicatorZ = nil;
    [accelLabelX release];
    accelLabelX = nil;
    [accelLabelY release];
    accelLabelY = nil;
    [accelLabelZ release];
    accelLabelZ = nil;
    [gravityIndicatorX release];
    gravityIndicatorX = nil;
    [gravityIndicatorY release];
    gravityIndicatorY = nil;
    [gravityIndicatorZ release];
    gravityIndicatorZ = nil;
    [gravityLabelX release];
    gravityLabelX = nil;
    [gravityLabelY release];
    gravityLabelY = nil;
    [gravityLabelZ release];
    gravityLabelZ = nil;
    [rotIndicatorX release];
    rotIndicatorX = nil;
    [rotIndicatorY release];
    rotIndicatorY = nil;
    [rotIndicatorZ release];
    rotIndicatorZ = nil;
    [rotLabelX release];
    rotLabelX = nil;
    [rotLabelY release];
    rotLabelY = nil;
    [rotLabelZ release];
    rotLabelZ = nil;
    
    [rotState release];
    rotState = nil;
    
    [timer invalidate];
    [motionManager stopDeviceMotionUpdates];
    [motionManager release];
        
    [rawAccelIndicatorX release];
    rawAccelIndicatorX = nil;
    [rawAccelIndicatorY release];
    rawAccelIndicatorY = nil;
    [rawAccelIndicatorZ release];
    rawAccelIndicatorZ = nil;
    [rawAccelLabelX release];
    rawAccelLabelX = nil;
    [rawAccelLabelY release];
    rawAccelLabelY = nil;
    [rawAccelLabelZ release];
    rawAccelLabelZ = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
