//
//  Created by Michael May on 2014/04/27.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Michael May. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

@import AudioToolbox;

#import "MMBViewController.h"

@interface MMBViewController ()
@property (nonatomic, assign, readonly) CFURLRef soundFileURLRef;
@property (nonatomic, assign) SystemSoundID soundFileID;
@end

@implementation MMBViewController

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(motion == UIEventSubtypeMotionShake) {
        [self ringTheBell];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self ringTheBell];
}

#pragma mark -

-(void)ringTheBell
{
    SystemSoundID soundFileID = [self soundFileID];
    
    AudioServicesPlayAlertSound(soundFileID);
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CFURLRef soundFileURLRef = [self soundFileURLRef];
    
    if(soundFileURLRef) {
        // Create a system sound object representing the sound file
        SystemSoundID soundFileID;
        OSStatus status = AudioServicesCreateSystemSoundID(soundFileURLRef,
                                                           &soundFileID);
        
        if(status == noErr) {
            [self setSoundFileID:soundFileID];
        } else {
            // fail
        }
    } else {
        // fail
    }
}

#pragma mark -

-(void)awakeFromNib
{
    CFBundleRef mainBundle = CFBundleGetMainBundle ();
    
    _soundFileURLRef  = CFBundleCopyResourceURL(mainBundle,
                                                CFSTR ("bell"),
                                                CFSTR ("wav"),
                                                NULL);
}

#pragma mark - 

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID([self soundFileID]);
}

@end
