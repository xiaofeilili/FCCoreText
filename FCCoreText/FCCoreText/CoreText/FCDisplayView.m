//
//  FCDisplayView.m
//  CoreText_Demo
//
//  Created by admin on 2019/5/22.
//  Copyright © 2019 admin. All rights reserved.
//

#import "FCDisplayView.h"
#import "FCCoreTextImageData.h"
#import <CoreText/CoreText.h>

@implementation FCDisplayView

- (void)setData:(FCCoreTextData *)data {
    if (_data != data) {
        _data = data;
    }
    CGRect rect = self.frame;
    rect.size.height = data.height;
    self.frame = rect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1.获取当前绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 2.旋转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
        for (FCCoreTextImageData *imageData in self.data.imageArray) {
            UIImage *image = [UIImage imageNamed:imageData.name];
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
    
}


@end
