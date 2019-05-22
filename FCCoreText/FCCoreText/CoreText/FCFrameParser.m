//
//  FCFrameParser.m
//  CoreText_Demo
//
//  Created by admin on 2019/5/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import "FCFrameParser.h"
#import "FCFrameParserConfig.h"
#import "FCCoreTextData.h"
#import "FCCoreTextImageData.h"
#import <CoreText/CoreText.h>

@implementation FCFrameParser

// 配置信息格式化
+ (NSDictionary *)attributesWithConfig:(FCFrameParserConfig *)config {
    
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpcing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpcing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpcing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpcing},
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(fontRef);
    CFRelease(theParagraphRef);
    return dict;
}

+ (FCCoreTextData *)parserTemplateFile:(NSString *)path config:(FCFrameParserConfig *)config {
    NSMutableArray *imageArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray];
    FCCoreTextData *data = [self parserAttributedContent:content config:config];
    data.imageArray = imageArray;
    
    return data;
}

+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(FCFrameParserConfig *)config imageArray:(NSMutableArray *)imageArray {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (data) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([arr isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in arr) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parserAttributedContentFromDict:dict config:config];
                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"img"]) {
                    // 创建CoreTextImageData，保存图片到imageArray数组中
                    FCCoreTextImageData *imageData = [[FCCoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    
                    // 创建空白占位符，并且设置它的CTRunDelegate信息
                    NSAttributedString *as = [self parserImageDataFromDict:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
    }
    return result;
}

+ (NSAttributedString *)parserAttributedContentFromDict:(NSDictionary *)dict config:(FCFrameParserConfig *)config {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesWithConfig:config]];
    
    // 设置颜色
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    
    // 设置字号
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }else if ([name isEqualToString:@"red"]){
        return [UIColor redColor];
    }else if ([name isEqualToString:@"black"]){
        return [UIColor blackColor];
    }else{
        return nil;
    }
}

+ (FCCoreTextData *)parserAttributedContent:(NSAttributedString *)content config:(FCFrameParserConfig *)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要绘制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的绘制高度保存到coreTextData实例中，最后返回CoreTextData实例
    FCCoreTextData *data = [[FCCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(FCFrameParserConfig *)config height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    
    return frame;
}

#pragma mark - 添加设置CTRunDelegate信息的方法
static CGFloat ascentCallBack(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallBack(void *ref) {
    return 0;
}

static CGFloat widthCallBack(void *ref) {
    return [(NSNumber *)[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

+ (NSAttributedString *)parserImageDataFromDict:(NSDictionary *)dict config:(FCFrameParserConfig *)config {
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBack;
    callBacks.getDescent = descentCallBack;
    callBacks.getWidth = widthCallBack;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)dict);
    
    // 使用OXFFFC作为占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}


@end
