//
//  FCCoreTextData.h
//  CoreText_Demo
//
//  Created by admin on 2019/5/22.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCCoreTextData : NSObject
/** 新增加的成员 */
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CTFrameRef ctFrame;

@end

NS_ASSUME_NONNULL_END
