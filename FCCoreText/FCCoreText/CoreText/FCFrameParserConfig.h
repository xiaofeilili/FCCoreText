//
//  FCFrameParserConfig.h
//  CoreText_Demo
//
//  Created by admin on 2019/5/22.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCFrameParserConfig : NSObject

@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat fontSize;
@property (nonatomic, assign)CGFloat lineSpace;
@property (nonatomic, strong)UIColor *textColor;

@end

NS_ASSUME_NONNULL_END
