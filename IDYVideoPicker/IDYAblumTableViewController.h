//
//  IDYAblumTableViewController.h
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDYImagePickerViewController.h"

@interface IDYAblumTableViewController : UITableViewController


/**
 初始化imagePicker

 @param imagePickerViewController imagePicker

 @return 当前类的实例对象
 */
- (id)initWithImagePickerViewController:(IDYImagePickerViewController *)imagePickerViewController;


@end
