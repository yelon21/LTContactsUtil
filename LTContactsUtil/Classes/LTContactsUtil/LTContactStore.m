//
//  LTContactStore.m
//  LTTools
//
//  Created by yelon on 16/4/7.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTContactStore.h"
#import <Contacts/Contacts.h>

@interface LTContactStore ()

@property (nonatomic, strong) NSMutableArray *personArray;
@end

@implementation LTContactStore

-(NSMutableArray <LTContactsInfo *>*)allMobileNoArray{
    
    NSMutableArray *mobileNos = [NSMutableArray array];
    
    NSArray *allContacts = [self contactsArray];
    
    for (LTContactsInfo *info in allContacts) {
        
        for (NSString *phone in info.tels) {
            
            LTContactsInfo *contactsInfo = [[LTContactsInfo alloc] init];
            contactsInfo.tel = phone;
            contactsInfo.name = info.name;
            
            [mobileNos addObject:contactsInfo];
        }
        
    }
    return mobileNos;
}

-(NSMutableArray <LTContactsInfo *>*)contactsArray{
    
    if (self.personArray) {
        
        return self.personArray;
    }
    else{
        
        return [self getContacts];
    }
}

- (NSMutableArray <LTContactsInfo *>*)getContacts{

    if (self.personArray == nil) {
        
        self.personArray = [NSMutableArray array];
    }
    
    if (@available(iOS 9.0, *)) {
        NSArray *keys = @[CNContactPhoneNumbersKey,CNContactGivenNameKey,CNContactFamilyNameKey];
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
        
        NSError *error;
        
        CNContactStore *contactStore = [[CNContactStore alloc]init];
        
        BOOL succeed = [contactStore enumerateContactsWithFetchRequest:request
                                                                 error:&error
                                                            usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                                                                
                                                                LTContactsInfo *info = [[LTContactsInfo alloc]init];
                                                                
                                                                NSString *fullName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
                                                                
                                                                info.name = fullName;
                                                                
                                                                NSArray *phones = contact.phoneNumbers;
                                                                
                                                                NSMutableArray *tels = [[NSMutableArray alloc] init];
                                                                
                                                                for(CNLabeledValue *value in phones) {
                                                                    
                                                                    CNPhoneNumber *phoneNumber = value.value;
                                                                    NSString *phone = phoneNumber.stringValue;
                                                                    
                                                                    [tels addObject:phone];
                                                                }
                                                                
                                                                info.tels = tels;
                                                                
                                                                [self.personArray addObject:info];
                                                            }];
        
        if (!succeed || error) {
            
            NSLog(@"error=%@",error);
        }
    } else {
        
    }
    
    return self.personArray;
}
//
+(void)LT_checkAuthorizationStatus:(void (^)(BOOL))resultBlock NS_AVAILABLE(10_11, 9_0){
    
    if (resultBlock) {
        
        LTConAuthorizationStatus status = [self LT_getAuthorizationStatus];
        if (status == LTConAuthorizationStatus_Authorized) {
            
            resultBlock(YES);
        }
        else{
            CNContactStore *contactStore = [[CNContactStore alloc]init];
            
            [contactStore requestAccessForEntityType:CNEntityTypeContacts
                                   completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                       
                                       if (error) {
                                           NSLog(@"Error: %@", error);
                                           resultBlock(NO);
                                       }else if (granted) {
                                           resultBlock(YES);
                                       }else {
                                           resultBlock(NO);
                                       }
                                   }];
        }
    }
}

+ (LTConAuthorizationStatus)LT_getAuthorizationStatus NS_AVAILABLE(10_11, 9_0){
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (status) {
        case CNAuthorizationStatusNotDetermined:
            return LTConAuthorizationStatus_NotDetermined;
        case CNAuthorizationStatusDenied:
            return LTConAuthorizationStatus_Denied;
        case CNAuthorizationStatusAuthorized:
            return LTConAuthorizationStatus_Authorized;
        default:
            return LTConAuthorizationStatus_Denied;
            break;
    }
}

@end
