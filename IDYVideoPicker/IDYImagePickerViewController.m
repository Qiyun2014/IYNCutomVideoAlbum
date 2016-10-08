//
//  IDYImagePickerViewController.m
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import "IDYImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IDYAblumTableViewController.h"

@interface IDYImagePickerViewController ()

@property (strong, nonatomic)   ALAssetsLibrary     *assetsLibrary;

@end

@implementation IDYImagePickerViewController

- (id)init{
    
    if (self == [super init]) {
        
        _assetsGroup    = [NSMutableArray array];
        _allAssets      = [NSMutableArray array];
        _smartImages    = [NSMutableArray array];
        _videoCounts    = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self openAblumeGroup:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            IDYAblumTableViewController *albumTableViewController = [[IDYAblumTableViewController alloc] initWithImagePickerViewController:self];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:albumTableViewController];
            [self addChildViewController:navi];
            albumTableViewController.title = NSLocalizedStringFromTableInBundle(@"idy_ablum_title",  @"IDYAblumString", [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"IDYVideoBundle" ofType:@"bundle"]],  @"title");
            [self.view addSubview:navi.view];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAssetsGroup:(NSMutableArray *)newAssetsGroup{
    
    if (newAssetsGroup != _assetsGroup) {
        
        [_assetsGroup removeAllObjects];
        _assetsGroup = nil;
        
        _assetsGroup = [newAssetsGroup mutableCopy];
    }
}


- (void)openAblumeGroup:(void (^) (void))completed{
    
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            /* 只获取视频文件的信息 */
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                
                if (result) [self.allAssets addObject:result];
                
                /* 获取第一个视频的缩略图 */
                if (index == 0 && result) [self.smartImages addObject:[UIImage imageWithCGImage:[result thumbnail]]];
                
                
                if (index == 0) {
                    
                    if (group.numberOfAssets) [self.assetsGroup addObject:group];
                    NSLog(@"name = %@",[group valueForProperty:ALAssetsGroupPropertyName]);
                    
                    /* 获取自定义相册视频的个数 */
                    [self.videoCounts addObject:@(group.numberOfAssets)];
                }
            }
            
            if (index == (group.numberOfAssets - 1)){
                
                if (completed) completed();
            }
        }];
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        NSString *errorMessage = nil;
        
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                break;
                
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                               message:errorMessage
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
        });
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:listGroupBlock
                                    failureBlock:failureBlock];
}


@end
