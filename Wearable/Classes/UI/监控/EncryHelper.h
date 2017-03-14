//
//  EncryHelper.h
//  Wearable
//
//  Created by Shinsoft on 17/2/26.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryHelper : NSObject

+ (NSData *)data;

+ (NSData*)PKCSSignBytesSHA256withRSA:(NSData*)plainData SecKeyRef:(SecKeyRef) privateKey;

+ (BOOL)PKCSVerifyBytesSHA256withRSA:(NSData*) plainData signature:(NSData*)signature publicKey:(SecKeyRef)publicKey;

+ (SecKeyRef)getPublicKeyReference:(NSData *)peerTag;

@end
