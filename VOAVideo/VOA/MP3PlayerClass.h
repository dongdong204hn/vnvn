//
//  MP3PlayerClass.h
//  JPTListeningLevel-3
//
//  Created by aiyuba on 12-1-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface MP3PlayerClass : NSObject {
}

//+ (void)timeSliderChanged:(UISlider *)slider 
//			   timeSlider:(UISlider *)timeSlider
//				localPlayer:(AVPlayer *)localPlayer 
//				   button:(UIButton *)playButton ;
//+ (void)playButton:(UIButton *)button 
//		 localPlayer:(AVPlayer *)localPlayer ;

+ (void)timeSliderChanged:(UISlider *)slider 
			   timeSlider:(UISlider *)timeSlider
              localPlayer:(AVPlayer *)localPlayer 
				   button:(UIButton *)playButton ;
+ (void)playButton:(UIButton *)button 
       localPlayer:(AVPlayer *)localPlayer ;

@end
