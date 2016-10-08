//
//  IDYAblumTableViewCell.m
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import "IDYAblumTableViewCell.h"

@implementation IDYAblumeModel @end


@interface IDYAblumTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ablumImageView;
@property (weak, nonatomic) IBOutlet UILabel *ablumName;
@property (weak, nonatomic) IBOutlet UILabel *ablumVideoCount;

@end

@implementation IDYAblumTableViewCell

- (void)setModel:(IDYAblumeModel *)model{
    
    _model = model;
    
    self.ablumImageView.image = model.image?model.image:nil;
    self.ablumName.text = model.abluemName;
    self.ablumVideoCount.text = [NSString stringWithFormat:@"%ld个视频",(long)model.count];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
