//
//  DocumentsDirectoryDirViewController.m
//  MovieLib
//
//  Copyright © 2016年 LoftLabo. All rights reserved.
//

#import "DocumentsDirectoryDirViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface DocumentsDirectoryDirViewController ()

@end

@implementation DocumentsDirectoryDirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.library = [[ALAssetsLibrary alloc] init];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *dir_array=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    self.av_array=[NSMutableArray array];
    for(NSString *item_name in dir_array) {
        NSString *file_path=[NSString stringWithFormat:@"%@/%@", documentsDirectory, item_name];
        NSURL* url = [NSURL fileURLWithPath:file_path];
        AVURLAsset *firstAsset = [AVURLAsset assetWithURL:url];
        if (firstAsset) {
            [self.av_array addObject:firstAsset];
        }
    }
    NSLog(@"file count=%ld", [dir_array count]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.av_array count];
}

- (UITableViewCell *)tableView:(UITableView *)arg_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.table_view dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    AVURLAsset *asset=[self.av_array objectAtIndex:indexPath.row];
    NSString *path=asset.URL.path;
    NSArray *warray=[path componentsSeparatedByString:@"/"];
    cell.textLabel.text=[warray lastObject];
    return cell;
}

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AVURLAsset *asset=[self.av_array objectAtIndex:indexPath.row];
    if ([self.library videoAtPathIsCompatibleWithSavedPhotosAlbum:asset.URL])
    {
        [self.library writeVideoAtPathToSavedPhotosAlbum:asset.URL
                                    completionBlock:^(NSURL *assetURL, NSError *error)
         {
             if (error)
             {
                 NSLog(@"SavedPhotosAlbum Error");
             }else{
                 [self.av_array removeObject:asset];
                 NSError *error2;
                 NSString *file_url=[asset.URL absoluteString];
                 NSArray *warray=[file_url componentsSeparatedByString:@"/"];
                 NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                 NSString *file_path=[NSString stringWithFormat:@"%@/%@", documentsDirectory, [warray lastObject]];
                 if ([[NSFileManager defaultManager] removeItemAtPath:file_path error:&error2]==NO) {
                     NSLog(@"File Remove Error");
                 }
                 [self.table_view reloadData];
             }
         }];
    }
}




@end
