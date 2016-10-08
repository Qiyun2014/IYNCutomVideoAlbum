//
//  IDYAblumListCollectionViewController.h
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TrimVideoCompletionWithHanlder) (UINavigationController *, NSString *);
typedef void (^TrimVideoErrorWithHanlder) (UINavigationController *, NSError *);


@interface IDYAblumListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



@interface IDYAblumListCollectionViewController : UICollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout;

@property (nonatomic, copy) NSMutableArray    *assets;
@property (nonatomic, copy) TrimVideoCompletionWithHanlder  completionWithHanlder;
@property (nonatomic, copy) TrimVideoErrorWithHanlder  errorWithHanlder;

@end
