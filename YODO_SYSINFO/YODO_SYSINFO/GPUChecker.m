//
//  GPUChecker.m
//  YODO_SYSINFO
//
//  Created by Bokdung on 3/16/24.
//

#import "GPUChecker.h"

#import "IOKit/IOKitLib.h"


#define GPU_UTILI_KEY(key, value)   static NSString * const GPU ## key ##Key = @#value;

GPU_UTILI_KEY(DeviceUtilization, Device Utilization %)
GPU_UTILI_KEY(RendererUtilization, Renderer Utilization %)
GPU_UTILI_KEY(TilerUtilization, Tiler Utilization %)
GPU_UTILI_KEY(HardwareWaitTime, hardwareWaitTime)
GPU_UTILI_KEY(FinishGLWaitTime, finishGLWaitTime)
GPU_UTILI_KEY(FreeToAllocGPUAddressWaitTime, freeToAllocGPUAddressWaitTime)
GPU_UTILI_KEY(ContextGLCount, contextGLCount)
GPU_UTILI_KEY(RenderCount, CommandBufferRenderCount)
GPU_UTILI_KEY(RecoveryCount, recoveryCount)
GPU_UTILI_KEY(TextureCount, textureCount)

@implementation GPUChecker
{
    NSDictionary        * _utilizationInfo;
}

+ (NSDictionary *)utilizeDictionary {
    NSDictionary *dictionary = nil;
    
    io_iterator_t iterator;
    if (IOServiceGetMatchingServices(kIOMainPortDefault, IOServiceNameMatching("sgx"), &iterator) == kIOReturnSuccess) {
        
        for (io_registry_entry_t regEntry = IOIteratorNext(iterator); regEntry; regEntry = IOIteratorNext(iterator)) {
            io_iterator_t innerIterator;
            if (IORegistryEntryGetChildIterator(regEntry, "IOService", &innerIterator) == kIOReturnSuccess) {
                for (io_registry_entry_t gpuEntry = IOIteratorNext(innerIterator); gpuEntry ; gpuEntry = IOIteratorNext(innerIterator)) {
                    CFMutableDictionaryRef serviceDictionary;
                    if (IORegistryEntryCreateCFProperties(gpuEntry, &serviceDictionary, kCFAllocatorDefault, kNilOptions) != kIOReturnSuccess) {
                        IOObjectRelease(gpuEntry);
                        continue;
                    } else {
                        dictionary = ((__bridge NSDictionary *)serviceDictionary)[@"PerformanceStatistics"];
                        
                        CFRelease(serviceDictionary);
                        IOObjectRelease(gpuEntry);
                        break;
                    }
                }
                IOObjectRelease(innerIterator);
                IOObjectRelease(regEntry);
                break;
            }
            IOObjectRelease(regEntry);
        }
        IOObjectRelease(iterator);
    }
    
    return dictionary;
}

+ (float)gpuUsage
{
    return [[self utilizeDictionary][GPUDeviceUtilizationKey] floatValue];
}

+ (GPUChecker *)current
{
    return [[self alloc] initWithDictionary:[self utilizeDictionary]];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _utilizationInfo = [dictionary copy];
    }
    return self;
}

- (NSInteger)deviceUtilization
{
    return [_utilizationInfo[GPUDeviceUtilizationKey] integerValue];
}

- (NSInteger)rendererUtilization
{
    return [_utilizationInfo[GPURendererUtilizationKey] integerValue];
}

- (NSInteger)tilerUtilization
{
    return [_utilizationInfo[GPUTilerUtilizationKey] integerValue];
}

- (int64_t)hardwareWaitTime
{
    return [_utilizationInfo[GPUHardwareWaitTimeKey] longLongValue];
}

- (int64_t)finishGLWaitTime
{
    return [_utilizationInfo[GPUFinishGLWaitTimeKey] longLongValue];
}

- (int64_t)freeToAllocGPUAddressWaitTime
{
    return [_utilizationInfo[GPUFreeToAllocGPUAddressWaitTimeKey] longLongValue];
}

- (NSInteger)contextGLCount
{
    return [_utilizationInfo[GPUContextGLCountKey] integerValue];
}

- (NSInteger)renderCount
{
    return [_utilizationInfo[GPURenderCountKey] integerValue];
}

- (NSInteger)recoveryCount
{
    return [_utilizationInfo[GPURecoveryCountKey] integerValue];
}

- (NSInteger)textureCount
{
    return [_utilizationInfo[GPUTextureCountKey] integerValue];
}

@end
