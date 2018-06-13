//
//  LTContactsBase.h
//  LTTools
//
//  Created by yelon on 16/4/7.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTContactsInfo.h"

typedef NS_ENUM(NSInteger, LTConAuthorizationStatus)
{
    LTConAuthorizationStatus_NotDetermined = 0,
    LTConAuthorizationStatus_Denied,
    LTConAuthorizationStatus_Authorized
};

@interface LTContactsBase : NSObject

@property (nonatomic, assign) NSMutableArray <LTContactsInfo *> *contactsArray;
@property (nonatomic, assign) NSMutableArray <LTContactsInfo *> *allMobileNoArray;

+ (void)LT_checkAuthorizationStatus:(void(^)(BOOL authorized))resultBlock;
+ (LTConAuthorizationStatus)LT_getAuthorizationStatus;
@end
