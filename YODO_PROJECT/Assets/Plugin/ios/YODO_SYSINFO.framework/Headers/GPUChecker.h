//
//  GPUChecker.h
//  YODO_SYSINFO
//
//  Created by Bokdung on 3/16/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPUChecker : NSObject
@property (nonatomic, readonly) NSInteger deviceUtilization;    // percent
@property (nonatomic, readonly) NSInteger rendererUtilization;  // percent
@property (nonatomic, readonly) NSInteger tilerUtilization;     // percent
@property (nonatomic, readonly) int64_t hardwareWaitTime;                   // nano second
@property (nonatomic, readonly) int64_t finishGLWaitTime;                   // nano second
@property (nonatomic, readonly) int64_t freeToAllocGPUAddressWaitTime;      // nano second
@property (nonatomic, readonly) NSInteger contextGLCount;
@property (nonatomic, readonly) NSInteger renderCount;
@property (nonatomic, readonly) NSInteger recoveryCount;
@property (nonatomic, readonly) NSInteger textureCount;

+ (float)gpuUsage;

@end

NS_ASSUME_NONNULL_END
