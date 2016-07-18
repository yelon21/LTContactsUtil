//
//  LTContactsUIUtil.m
//  ABContacts
//
//  Created by yelon on 16/3/14.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTContactsUIUtil.h"

#import "LTAddressBookSelect.h"
#import "LTContactSelect.h"

@interface LTContactsUIUtil ()<UIActionSheetDelegate>

@property(nonatomic,strong) NSObject *select;
@property(nonatomic,strong) void (^didSelectPerson)(NSString *name,NSString *tel);

@end

@implementation LTContactsUIUtil

+ (BOOL)checkAuthorizationStatus{

    Class class = NSClassFromString(@"CNContactPickerViewController");
    
    if (class) {
    
        return [LTContactSelect checkAuthorizationStatus];
    }
    else{
    
        return [LTAddressBookSelect checkAuthorizationStatus];
    }
}

- (void)showAddressBookUIFromVC:(UIViewController *)viewCon
                      didSelect:(void(^)(NSString *name,NSString *tel))didSelectPerson{

    self.didSelectPerson = didSelectPerson;
    
    Class class = NSClassFromString(@"CNContactPickerViewController");
    
    if (class) {
        
        self.select = [[LTContactSelect alloc]init];
        [(LTContactSelect *)self.select showAddressBookUIFromVC:viewCon
                              didSelect:^(NSString *name, NSArray *tels) {
                                  
                                  if ([tels count]>1) {
                                      
                                      [self showSelectFrom:viewCon
                                                      name:name
                                                      tels:tels];
                                  }
                                  else{
                                  
                                      [self didSelect:name tel:[tels firstObject]];
                                  }
                              }];
    }
    else{
    
        self.select = [[LTAddressBookSelect alloc]init];
        [(LTAddressBookSelect *)self.select showAddressBookUIFromVC:viewCon
                              didSelect:^(NSString *name, NSArray *tels) {
                                  
                                  if ([tels count]>1) {
                                      
                                      [self showSelectFrom:viewCon
                                                      name:name
                                                      tels:tels];
                                  }
                                  else{
                                      
                                      [self didSelect:name tel:[tels firstObject]];
                                  }
                              }];
    }
}

- (void)didSelect:(NSString *)name tel:(NSString *)tel{

    if (self.telOnlyNumber) {
        
        NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                       invertedSet ];
        tel = [[tel componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    }
    
    if (self.didSelectPerson) {
        
        self.didSelectPerson(name,tel);
    }
}

- (void)showSelectFrom:(UIViewController *)viewCon
                  name:(NSString *)name
                  tels:(NSArray *)tels{
    
    NSMutableArray *telsArray = [[NSMutableArray alloc]init];

    for (NSString *tel in tels) {
        
        [telsArray addObject:@{@"title":tel,@"value":tel}];
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:name
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (alertVC) {
        
        for (NSDictionary *dic in telsArray) {
            
            [alertVC addAction:[UIAlertAction actionWithTitle:dic[@"title"]
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          NSLog(@"value =%@", dic[@"value"]);
                                                          [self didSelect:dic[@"title"]
                                                                      tel:dic[@"value"]];
                                                      }]];
        }
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      
                                                  }]];
        
        [viewCon presentViewController:alertVC animated:YES completion:nil];
    }
    else{
    
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:name
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil];
        
        for (NSDictionary *dic in telsArray) {
            
            [sheet addButtonWithTitle:dic[@"title"]];
        }
        [sheet addButtonWithTitle:@"取消"];
        
        [sheet showInView:viewCon.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"取消"]) {
        
        return;
    }
    [self didSelect:actionSheet.title tel:title];
}

@end
