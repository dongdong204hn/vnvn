//
//  VoaViewCell.h
//  VOA
//
//  Created by song zhao on 12-2-8.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

@interface VoaViewCell : UITableViewCell
{
    UIImageView *myImage;
    UILabel *myTitle;
    UILabel *myDate;
    UILabel *collectDate;
//    UILabel *hot;
//    UILabel *read;
    UIImageView *hotImg;
    UIImageView *readImg;
}

@property (nonatomic,retain) IBOutlet UIImageView *myImage;
@property (nonatomic,retain) IBOutlet UIImageView *localImg;
@property (nonatomic,retain) IBOutlet UIImageView *hotImg;
@property (nonatomic,retain) IBOutlet UIImageView *readImg;
@property (nonatomic,retain) IBOutlet UILabel *myTitle;
@property (nonatomic,retain) IBOutlet UILabel *myDate;
@property (nonatomic,retain) IBOutlet UILabel *collectDate;
//@property (nonatomic,retain) IBOutlet UILabel *hot;
//@property (nonatomic,retain) IBOutlet UILabel *read;

@end
