//
//  XLSingleton.h
//
//  Created by shinsoft on 16/07/20.
//  Copyright © 2016年 shinsoft. All rights reserved.
//

#ifndef XLSingleton_h
#define XLSingleton_h

// .h文件
#define XLSingletonH(name) + (instancetype)shared##name;

// .m文件
#if __has_feature(objc_arc)

#define XLSingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
}

#else

#define XLSingletonM(name) \
static id _instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [[self alloc] init]; \
}); \
return _instace; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instace; \
} \
\
- (oneway void)release { } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return 1;} \
- (id)autorelease { return self;}

#endif

#endif /* XLSingleton_h */
