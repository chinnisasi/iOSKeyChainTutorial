//
//  SecureKeyChain.m
//
//  Created by Sasidhar Koti on 25/08/15.
//  Copyright (c) 2015 Sasidhar@reimagine. All rights reserved.
//

#import <Security/Security.h>
#import "SecureKeyChain.h"

static NSString *serviceName = @"com.sasi.reimagine";

@interface SecureKeyChain()
- (NSMutableDictionary*) newItemDictionaryForKey:(NSString*)key;
- (BOOL)addItem:(NSData*)item forKey:(NSString*)key;
@end

@implementation SecureKeyChain

- (NSMutableDictionary*) newItemDictionaryForKey:(NSString*)key {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:serviceName forKey:(__bridge id)kSecAttrService];
    return dict;
}

- (BOOL)addItem:(NSData*)item forKey:(NSString*)key {
    NSMutableDictionary *dict = [self newItemDictionaryForKey:key];
    [dict setObject:item forKey:(__bridge id)kSecValueData];
    OSStatus ossstatus = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
    if(errSecSuccess != ossstatus) {
        NSLog(@"Unable to add item for key %@ %d request dict:%@",key,(int)ossstatus,dict);
    }
    return (errSecSuccess == ossstatus);
}

- (BOOL) setItem:(NSData*)item forKey:(NSString*)key {
    BOOL result = NO;
    if([item length] > 0) {
        
        if([self itemForKey:key]) //if exists
        {
            [self deleteItemForKey:key];
        }
        result =  [self addItem:item forKey:key];
        result = [self update:key];
    }
    return result;
}

- (NSData*) itemForKey:(NSString*)key {
    NSMutableDictionary *dict = [self newItemDictionaryForKey:key];
    [dict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [dict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    NSData *result = nil;
    OSStatus ossstatus = SecItemCopyMatching((__bridge CFDictionaryRef)dict,(void *)&result);
    if(errSecSuccess != ossstatus) {
        NSLog(@"Unable to fetch item for key %@ %d with result %@ for request dict %@",key,(int)ossstatus,result,dict);
    }
    return result;
}

- (BOOL) deleteItemForKey:(NSString*)key {
    NSMutableDictionary *dict = [self newItemDictionaryForKey:key];
    OSStatus ossstatus = SecItemDelete((__bridge CFDictionaryRef)dict);
    if(!(errSecSuccess == ossstatus)) {
        NSLog(@"Unable to delete item for key %@ %d for request dict %@",key,(int)ossstatus,dict);
    }
    return (errSecSuccess == ossstatus);
}

- (BOOL)update:(NSString*)key
{
    BOOL result = NO;
    NSMutableDictionary *dict = [self newItemDictionaryForKey:key];
    NSData* itemData =  [self itemForKey:key];
    if(itemData.length > 0) {
        NSDictionary *updatedAttributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
         (__bridge id)kSecAttrAccessibleAfterFirstUnlock, kSecAttrAccessible,
         (CFDataRef)itemData, kSecValueData,
         nil];
        OSStatus updateItemStatus = SecItemUpdate((CFDictionaryRef)dict,
                                                  (CFDictionaryRef)updatedAttributes);
        result = (errSecSuccess == updateItemStatus);
    }
    return result;
}
@end
