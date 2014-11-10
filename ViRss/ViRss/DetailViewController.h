//
//  DetailViewController.h
//  ViRss
//
//  Created by lhs on 14/10/27.
//  Copyright (c) 2014年 lhs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController <UISplitViewControllerDelegate, NSURLConnectionDelegate, NSXMLParserDelegate>
@property (nonatomic, strong) NSString *textInfo;
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSMutableData *rssData;
@property (nonatomic, strong) NSMutableArray *entries;
@end
