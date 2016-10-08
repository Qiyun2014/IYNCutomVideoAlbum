//
//  IDYAblumTableViewCell.h
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IDYAblumeModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *abluemName;
@property (nonatomic) NSInteger count;

@end



@interface IDYAblumTableViewCell : UITableViewCell

@property (nonatomic, copy) IDYAblumeModel *model;

@end
