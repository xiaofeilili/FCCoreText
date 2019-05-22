//
//  FCFrameParser.h
//  CoreText_Demo
//
//  Created by admin on 2019/5/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCCoreTextData.h"

@class FCFrameParserConfig;

NS_ASSUME_NONNULL_BEGIN

@interface FCFrameParser : NSObject

/**
 * 配置信息格式化
 *
 * @param config 配置信息
 */
+ (NSDictionary *)attributesWithConfig:(FCFrameParserConfig *)config;

/**
 * 给内容设置配置信息
 *
 * @param content 内容
 * @param config  配置信息
 */
+ (FCCoreTextData *)parserAttributedContent:(NSAttributedString *)content config:(FCFrameParserConfig *)config;

/**
 * 给内容设置配置信息
 */
+ (FCCoreTextData *)parserTemplateFile:(NSString *)path config:(FCFrameParserConfig *)config;


@end

NS_ASSUME_NONNULL_END
