//
//  XFCoreTextImageData.h
//  CoreText_Demo
//
//  Created by admin on 2019/5/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCCoreTextImageData : NSObject

// 图片资源名称
@property (nonatomic, copy)NSString *name;
// 图片位置的起始点
@property (nonatomic, assign)CGFloat position;
// 图片的尺寸
@property (nonatomic, assign)CGRect imagePosition;

@end

NS_ASSUME_NONNULL_END
