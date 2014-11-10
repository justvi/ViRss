//
//  Post.h
//  ViRss
//
//  Created by lhs on 14/11/10.
//  Copyright (c) 2014年 lhs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *wid;
@property (nonatomic, strong) NSString *content;

@end
