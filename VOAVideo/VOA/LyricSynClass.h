//
//  LyricSyn.h
//  JPTListeningLevel-3
//
//  Created by zzl on 12-1-11.
//  Copyright 2012 iyuba. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TextScrollView.h"
#import "RegexKitLite.h"
#import "MyLabel.h"

@interface LyricSynClass : NSObject{
    id <MyLabelDelegate> delegate;
}
@property (nonatomic,retain)id <MyLabelDelegate> delegate;

+ (void)lyricSyn : (NSMutableArray *)lyricLabelArray 
lyricCnLabelArray: (NSMutableArray *)lyricCnLabelArray 
		   index : (NSMutableArray *)indexArray
			time : (NSMutableArray *)timeArray
	   localPlayer : (AVPlayer *)mp3Player 
		  scroll : (TextScrollView *)textScroll ;//歌词

//+ (void)lyricSynNet : (NSMutableArray *)lyricLabelArray 
//   lyricCnLabelArray: (NSMutableArray *)lyricCnLabelArray 
//              index : (NSMutableArray *)indexArray
//               time : (NSMutableArray *)timeArray
//        localPlayer : (AVPlayer *)mp3Player 
//             scroll : (TextScrollView *)textScroll ;//歌词

+ (void)preLyricSyn: (NSMutableArray *)timeArray
       localPlayer : (AVPlayer *)mp3Player;

+ (void)aftLyricSyn: (NSMutableArray *)timeArray
       localPlayer : (AVPlayer *)mp3Player;

//+ (void)preLyricSynNet: (NSMutableArray *)timeArray
//          localPlayer : (AVPlayer *)mp3Player;
//
//+ (void)aftLyricSynNet: (NSMutableArray *)timeArray
//          localPlayer : (AVPlayer *)mp3Player;

+ (int)lyricView : (NSMutableArray *)lyricLabelArray 
lyricCnLabelArray: (NSMutableArray *)lyricCnLabelArray 
           index : (NSMutableArray *)indexArray 
           lyric : (NSMutableArray *)lyricArray
         lyricCn : (NSMutableArray *)lyricCnArray    
          scroll : (TextScrollView *)textScroll 
  myLabelDelegate: (id <MyLabelDelegate>) myLabelDelegate
        engLines : (int *)engLines //歌词显示
         cnLines : (int *)cnLines ;//歌词显示

+ (UIImage*)screenshot:(CGRect) senRect;
@end
