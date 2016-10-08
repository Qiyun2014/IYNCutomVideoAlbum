//
//  IDYAblumListCollectionViewController.m
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import "IDYAblumListCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface _IDYCustomCellBackground : UIView

@end

@implementation _IDYCustomCellBackground

- (void)drawRect:(CGRect)rect
{
    // draw a rounded rect bezier path filled with blue
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    bezierPath.lineWidth = 5.0f;
    [[UIColor blackColor] setStroke];
    
    UIColor *fillColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1]; // color equivalent is #87ceeb
    [fillColor setFill];
    
    [bezierPath stroke];
    [bezierPath fill];
    CGContextRestoreGState(aRef);
}

@end


@implementation IDYAblumListCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        _IDYCustomCellBackground *backgroundView = [[_IDYCustomCellBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
        
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

@end


@interface IDYAblumListCollectionViewController ()<UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIVideoEditorControllerDelegate>

@end

@implementation IDYAblumListCollectionViewController

static NSString * const reuseIdentifier = @"IDYAblumListCell";

- (void)setAssets:(NSMutableArray *)newAssets{
    
    if (newAssets != _assets) {
        
        [_assets removeAllObjects];
        _assets = nil;
        
        _assets = [newAssets mutableCopy];
    }
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self == [super initWithCollectionViewLayout:layout]) {
        
        self.collectionView.collectionViewLayout = layout;
        self.assets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [resPath stringByAppendingPathComponent:@"IDYVideoBundle.bundle"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"IDYAblumListCell" bundle:[NSBundle bundleWithPath:path]] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(120, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 0, 10);
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([self.assets.firstObject isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *group = (ALAssetsGroup *)self.assets.firstObject;
        return group.numberOfAssets;

    }else
        return self.assets.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IDYAblumListCell *listCell = (IDYAblumListCell *)cell;
    
    if ([self.assets.firstObject isKindOfClass:[ALAssetsGroup class]]) {
        
        ALAssetsGroup *group = (ALAssetsGroup *)self.assets.firstObject;
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (indexPath.row == index){
                
                listCell.imageView.image = [UIImage imageWithCGImage:[result thumbnail]];
                double value = [[result valueForProperty:ALAssetPropertyDuration] doubleValue]; //Find the Duraion
                [listCell.titleLabel setText:[self timeFormatted:value]];
            }
        }];
        
    }else{
        
        ALAsset *asset = self.assets[indexPath.row];
        listCell.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
        
        double value = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue]; //Find the Duraion
        [listCell.titleLabel setText:[self timeFormatted:value]];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    IDYAblumListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    //cell.titleLabel.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    // load the image for this cell
    //NSString *imageToLoad = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    //cell.imageView.image = [UIImage imageNamed:imageToLoad];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __block NSURL *fileUrl;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if ([self.assets.firstObject isKindOfClass:[ALAssetsGroup class]]) {
            
            ALAssetsGroup *group = (ALAssetsGroup *)self.assets.firstObject;
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (indexPath.row == index){
                    
                    //fileUrl = result.defaultRepresentation.url;
                    fileUrl = [result valueForProperty:ALAssetPropertyAssetURL];
                    
                    NSLog(@"url = %@",[result valueForProperty:ALAssetPropertyURLs]);
                    NSLog(@"url2 = %@",[result valueForProperty:ALAssetPropertyAssetURL]);
                }
            }];
            
        }else{
            
            ALAsset *asset = self.assets[indexPath.row];
            fileUrl = asset.defaultRepresentation.url;
        }
        
        if (fileUrl.path) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIVideoEditorController* videoEditor = [[UIVideoEditorController alloc] init];
                videoEditor.delegate = self;
                
                if ([UIVideoEditorController canEditVideoAtPath:fileUrl.absoluteString] || [UIVideoEditorController canEditVideoAtPath:fileUrl.path])
                {
                    videoEditor.videoPath = fileUrl.absoluteString;
                    videoEditor.videoMaximumDuration = 10.0;
                    videoEditor.videoQuality = UIImagePickerControllerQualityTypeHigh;
                    [self presentViewController:videoEditor animated:YES completion:nil];
                }else
                {
                    NSLog(@"视频无法编辑");
                }
            });
        }
    });
}

#pragma mark    -   imagePicker delegate


/**
 edited video is saved to a path in app's temporary directory
 
 @param editor          编辑视频控制器
 @param editedVideoPath 编辑完成之后的视频保存路径
 */
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath{
    
    NSLog(@"视频保存成功  %@",editedVideoPath);

    if (self.completionWithHanlder) {
        
        self.completionWithHanlder(editor,editedVideoPath);
    }
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error{
    
    NSLog(@"视频编辑失败  %@",[error description]);
    
    if (self.errorWithHanlder) {
        
        self.errorWithHanlder(editor, error);
    }
}


#pragma mark    -   UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([navigationController isKindOfClass:[UIVideoEditorController class]]) {
        
        id object = navigationController.navigationBar.items.lastObject;
        UINavigationItem *buttonItem = (UINavigationItem *)object;
        buttonItem.title = NSLocalizedStringFromTableInBundle(@"idy_ablum_title_editVideo",  @"IDYAblumString", [NSBundle bundleForClass:IDYAblumListCollectionViewController.class],  @"eidtVideo");
        buttonItem.backBarButtonItem.title = NSLocalizedStringFromTableInBundle(@"idy_ablum_back",  @"IDYAblumString", [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"IDYVideoBundle" ofType:@"bundle"]],  @"back");
        
        UIBarButtonItem *rightItem = buttonItem.rightBarButtonItems.lastObject;
        UIBarButtonItem *leftItem = buttonItem.leftBarButtonItems.lastObject;
        
        UIButton *trimButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [trimButton setFrame:CGRectMake(CGRectGetWidth(navigationController.view.frame) - 100, CGRectGetHeight(navigationController.view.frame) - 38, 100, 30)];
        [trimButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [trimButton setTitle:NSLocalizedStringFromTableInBundle(@"idy_ablum_edit",  @"IDYAblumString", [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"IDYVideoBundle" ofType:@"bundle"]],  @"edit") forState:UIControlStateNormal];
        [trimButton addTarget:rightItem.target action:rightItem.action forControlEvents:UIControlEventTouchUpInside];
        [navigationController.view addSubview:trimButton];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, trimButton.frame.origin.y, 100, 30)];
        [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cancelButton setTitle:NSLocalizedStringFromTableInBundle(@"idy_ablum_cancel",  @"IDYAblumString", [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"IDYVideoBundle" ofType:@"bundle"]],  @"cancel") forState:UIControlStateNormal];
        [cancelButton addTarget:leftItem.target action:leftItem.action forControlEvents:UIControlEventTouchUpInside];
        [navigationController.view addSubview:cancelButton];
        
        [viewController.navigationController setNavigationBarHidden:YES animated:YES];
    }
}



- (NSString *)timeFormatted:(double)totalSeconds{
    
    NSTimeInterval timeInterval = totalSeconds;
    long seconds = lroundf(timeInterval); // Modulo (%) operator below needs int or long
    int hour = 0;
    int minute = seconds/60.0f;
    int second = seconds % 60;
    if (minute > 59) {
        hour = minute/60;
        minute = minute%60;
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    }
    else{
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
