//
//  DocumentsDirectoryDirViewController.h
//  MovieLib
//
//  Copyright © 2016年 LoftLabo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DocumentsDirectoryDirViewController : UIViewController <UITabBarControllerDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *av_array;
@property (weak, nonatomic) IBOutlet UITableView *table_view;
@property (strong, nonatomic) ALAssetsLibrary *library;

@end
