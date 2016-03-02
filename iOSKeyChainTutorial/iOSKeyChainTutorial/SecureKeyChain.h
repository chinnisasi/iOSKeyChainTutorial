//
//  SecureKeyChain.h
//
//  Created by Sasidhar Koti on 25/08/15.
//  Copyright (c) 2015 Sasidhar@reimagine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecureKeyChain : NSObject

/*
  Stores Item in keyChain
 */
- (BOOL) setItem:(NSData*)item forKey:(NSString*)key;

/*
  Retrives item from keyChain
*/
- (NSData*) itemForKey:(NSString*)key;
/*
 Deletes item from keyChain
 */
- (BOOL) deleteItemForKey:(NSString*)key;
/*This method is used to update the key chain items to make accessible even when passcode is set for the device
 */
- (BOOL)update:(NSString*)key;
@end
