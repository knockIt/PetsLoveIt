//
//  LocalUserInfoModelClass.m
//  TeamWork
//
//  Created by HY on 14-6-18.
//  Copyright (c) 2014年 junfrost. All rights reserved.
//

#import "LocalUserInfoModelClass.h"

@implementation LocalUserInfoModelClass

-(void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"userIcon"]){
        self.user_icon = value;
    }
    else
        [super setValue:value forKey:key];
}




//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.uId forKey:@"uId"];
    [encoder encodeObject:self.uName forKey:@"uName"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.nickName forKey:@"nickName"];
    [encoder encodeObject:self.user_icon forKey:@"user_icon"];
    [encoder encodeObject:self.userGrade forKey:@"userGrade"];
    [encoder encodeObject:self.userIntegral forKey:@"userIntegral"];
    [encoder encodeObject:self.userToken forKey:@"userToken"];
    [encoder encodeObject:self.todaySigned forKey:@"todaySigned"];
    [encoder encodeObject:self.deliveryAddress forKey:@"deliveryAddress"];
    [encoder encodeObject:self.loginType forKey:@"loginType"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.accountName forKey:@"accountName"];
    [encoder encodeObject:self.otherType forKey:@"otherType"];
    [encoder encodeObject:self.otherAccount forKey:@"otherAccount"];
    [encoder encodeObject:self.messageVibration forKey:@"messageVibration"];
    [encoder encodeObject:self.messageVoice forKey:@"messageVoice"];
    [encoder encodeObject:self.messageCornerMark forKey:@"messageCornerMark"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.uId = [decoder decodeObjectForKey:@"uId"];
        self.uName = [decoder decodeObjectForKey:@"uName"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.nickName = [decoder decodeObjectForKey:@"nickName"];
        self.user_icon = [decoder decodeObjectForKey:@"user_icon"];
        self.userGrade = [decoder decodeObjectForKey:@"userGrade"];
        self.userIntegral = [decoder decodeObjectForKey:@"userIntegral"];
        self.userToken = [decoder decodeObjectForKey:@"userToken"];
        self.todaySigned = [decoder decodeObjectForKey:@"todaySigned"];
        self.deliveryAddress = [decoder decodeObjectForKey:@"deliveryAddress"];
        self.loginType = [decoder decodeObjectForKey:@"loginType"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.accountName = [decoder decodeObjectForKey:@"accountName"];
        self.otherType = [decoder decodeObjectForKey:@"otherType"];
        self.otherAccount = [decoder decodeObjectForKey:@"otherAccount"];
        self.messageVibration = [decoder decodeObjectForKey:@"messageVibration"];
        self.messageVoice = [decoder decodeObjectForKey:@"messageVoice"];
        self.messageCornerMark = [decoder decodeObjectForKey:@"messageCornerMark"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
    
    [theCopy setUId:[self.uId copy]];
    [theCopy setUName:[self.uName copy]];
    [theCopy setSex:[self.sex copy]];
    [theCopy setMobile:[self.mobile copy]];
    [theCopy setEmail:[self.email copy]];
    [theCopy setStatus:[self.status copy]];
    [theCopy setNickName:[self.nickName copy]];
    [theCopy setUser_icon:[self.user_icon copy]];
    [theCopy setUserGrade:[self.userGrade copy]];
    [theCopy setUserIntegral:[self.userIntegral copy]];
    [theCopy setUserToken:[self.userToken copy]];
    [theCopy setTodaySigned:[self.todaySigned copy]];
    [theCopy setDeliveryAddress:[self.deliveryAddress copy]];
    [theCopy setLoginType:[self.loginType copy]];
    [theCopy setPassword:[self.password copy]];
    [theCopy setAccountName:[self.accountName copy]];
    [theCopy setOtherType:[self.otherType copy]];
    [theCopy setOtherAccount:[self.otherAccount copy]];
    [theCopy setMessageVibration:[self.messageVibration copy]];
    [theCopy setMessageVoice:[self.messageVoice copy]];
    [theCopy setMessageCornerMark:[self.messageCornerMark copy]];
    
    return theCopy;
}
@end
