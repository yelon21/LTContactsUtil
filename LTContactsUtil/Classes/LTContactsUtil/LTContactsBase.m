//
//  LTContactsBase.m
//  LTTools
//
//  Created by yelon on 16/4/7.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTContactsBase.h"

@implementation LTContactsBase

+ (void)LT_checkAuthorizationStatus:(void(^)(BOOL authorized))resultBlock;{

    if (resultBlock) {
        resultBlock(NO);
    }
}

+ (LTConAuthorizationStatus)LT_getAuthorizationStatus{

    return LTConAuthorizationStatus_NotDetermined;
}

@end
