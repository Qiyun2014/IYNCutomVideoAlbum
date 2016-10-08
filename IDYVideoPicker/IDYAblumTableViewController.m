//
//  IDYAblumTableViewController.m
//  GMPhotoPicker
//
//  Created by qiyun on 16/9/30.
//  Copyright © 2016年 Guillermo Muntaner Perelló. All rights reserved.
//

#import "IDYAblumTableViewController.h"
#import <AssetsLibrary/ALAssetsGroup.h>
#import "IDYAblumTableViewCell.h"
#import "IDYAblumListCollectionViewController.h"

@interface IDYAblumTableViewController ()

@property (strong, nonatomic) IDYImagePickerViewController  *imagePickerViewController;
@property (strong, nonatomic) NSMutableArray    *datas;

@end

@implementation IDYAblumTableViewController

- (id)initWithImagePickerViewController:(IDYImagePickerViewController *)imagePickerViewController{
    
    if (self == [super init]) {
        
        self.imagePickerViewController = imagePickerViewController;
        
        IDYAblumeModel *model = [[IDYAblumeModel alloc] init];
        model.image = self.imagePickerViewController.smartImages.firstObject;
        model.abluemName = @"所有视频";
        model.count = self.imagePickerViewController.allAssets.count;
        
        self.datas = [NSMutableArray arrayWithObjects:model, nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancleAction:)];
    self.navigationItem.leftBarButtonItem = cancleItem;
    
    [self.imagePickerViewController.assetsGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        id object = self.imagePickerViewController.smartImages[idx];
        
        IDYAblumeModel *model = [[IDYAblumeModel alloc] init];
        model.image = [object isKindOfClass:[UIImage class]]?object:nil;
        model.abluemName = [obj valueForProperty:ALAssetsGroupPropertyName];
        model.count = [self.imagePickerViewController.videoCounts[idx] integerValue];
        
        [self.datas addObject:model];
    }];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"IDYAblumTableViewCell";
    
    IDYAblumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"IDYVideoBundle" ofType:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
        
        cell = [[resourceBundle loadNibNamed:cellIdentifier owner:self options:nil] firstObject];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    IDYAblumeModel *model = (IDYAblumeModel *) self.datas[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    IDYAblumListCollectionViewController *ablumListVC = [[IDYAblumListCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    if (!indexPath.row) ablumListVC.assets = [NSMutableArray arrayWithArray:self.imagePickerViewController.allAssets];
    else
        ablumListVC.assets = [NSMutableArray arrayWithObjects:self.imagePickerViewController.assetsGroup[indexPath.row - 1], nil];

    IDYAblumeModel *model = (IDYAblumeModel *)self.datas[indexPath.row];
    ablumListVC.title = model.abluemName;
    
    if (self.imagePickerViewController.delegate && [self.imagePickerViewController.delegate respondsToSelector:@selector(trimVideoOfStart:)]) {
        [self.imagePickerViewController.delegate trimVideoOfStart:ablumListVC];
    }
    
    ablumListVC.completionWithHanlder = ^(UINavigationController *vc, NSString *path){
        
        if (self.imagePickerViewController.delegate && [self.imagePickerViewController.delegate respondsToSelector:@selector(trimVideoOfFinished:editVideoOfPath:)]) {
            [self.imagePickerViewController.delegate trimVideoOfFinished:vc editVideoOfPath:path];
        }
    };
    
    ablumListVC.errorWithHanlder = ^(UINavigationController *vc, NSError *err){

        if (self.imagePickerViewController.delegate && [self.imagePickerViewController.delegate respondsToSelector:@selector(trimVideoOfError:error:)]) {
            
            [self.imagePickerViewController.delegate trimVideoOfError:vc error:err];
        }
    };
    [self.navigationController pushViewController:ablumListVC animated:YES];
}

- (void)cancleAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.imagePickerViewController.delegate respondsToSelector:@selector(trimVideoOfCancel:)] && self.imagePickerViewController.delegate){
        [self.imagePickerViewController.delegate trimVideoOfCancel:self.navigationController];
    }
}


@end
