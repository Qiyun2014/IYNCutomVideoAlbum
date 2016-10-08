//
//  IDYImagePickerViewController.h
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDYVideoPickerDelegate <NSObject>

@optional

- (void)trimVideoOfStart:(nonnull UIViewController *)trimViewController;
- (void)trimVideoOfFinished:(nonnull UINavigationController *)navigationController editVideoOfPath:(nonnull NSString *)path;
- (void)trimVideoOfCancel:(nonnull UINavigationController *)navigationController;
- (void)trimVideoOfError:(nonnull UINavigationController *)navigationController error:(nonnull NSError *)error;

@end


NS_ASSUME_NONNULL_BEGIN
@interface IDYImagePickerViewController : UIViewController

/**
 自定义相册集合
 */
@property (copy, nonatomic, readonly) NSMutableArray  *assetsGroup;


/**
 所有的视频集合
 */
@property (strong, nonatomic, readonly) NSMutableArray  *allAssets;


/**
 所有的缩略图集合
 */
@property (strong, nonatomic, readonly)   NSMutableArray      *smartImages;


/**
 集合对应的视频个数
 */
@property (strong, nonatomic, readonly)   NSMutableArray      *videoCounts;


@property (weak, nonatomic) id<IDYVideoPickerDelegate> delegate;


@end
NS_ASSUME_NONNULL_END
