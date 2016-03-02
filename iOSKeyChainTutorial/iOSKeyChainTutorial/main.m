//
//  main.m
//  iOSKeyChainTutorial
//
//  Created by Sasidhar Koti on 02/03/16.
//  Copyright © 2016 Sasidhar Koti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecureKeyChain.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        SecureKeyChain * secureKeyChain = [[SecureKeyChain alloc]init];
        NSString *str = @"sasidhar@reimagine";
        [secureKeyChain setItem:[str dataUsingEncoding:NSUTF8StringEncoding] forKey:@"name"];
        
        NSData* data = [secureKeyChain itemForKey:@"name"];
        NSString* newStr = [NSString stringWithUTF8String:[data bytes]];

        NSLog(@"name: %@", newStr);
        [secureKeyChain deleteItemForKey:@"name"];
        
    }
    return 0;
}
