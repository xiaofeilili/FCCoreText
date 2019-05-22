//
//  FCFrameParserConfig.m
//  CoreText_Demo
//
//  Created by admin on 2019/5/22.
//  Copyright © 2019 admin. All rights reserved.
//

#import "FCFrameParserConfig.h"

@implementation FCFrameParserConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.width = 200.f;
        self.fontSize = 17;
        self.lineSpace = 5;
        self.textColor = [UIColor blackColor];
    }
    return self;
}

@end
