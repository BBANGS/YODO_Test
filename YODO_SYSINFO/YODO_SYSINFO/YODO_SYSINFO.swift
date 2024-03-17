//
//  SysInfoChecker.swift
//  YODO_SYSINFO
//
//  Created by Bokdung on 3/16/24.
//

import Foundation

public struct YODO_SYSINFO {
    static var sys_inst:SysInfo? = nil
    static var onCallback: ((Double, Float, Int)->Void)? = nil
    static var calltimer: Timer? = nil
    
    static func runTracking(callback: @convention(c) @escaping (Double, Float, Int) -> Void) {
        sys_inst = SysInfo()
        onCallback = callback
        if calltimer == nil {
            calltimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { timer in
                let cpuusage:Double = (sys_inst?.cpuUsage())!
                let gpuusage:Float = (sys_inst?.gpuUsage())!
                let memusage = sys_inst?.memoryUsage()
                onCallback!(cpuusage, gpuusage, memusage!.0)
            }
        }
    }
    
    static func stopTracking() {
        if calltimer != nil {
            calltimer?.invalidate()
            calltimer = nil
        }
        sys_inst = nil
    }
}

public struct SysInfo {
    fileprivate var prev_cpu_info_list: processor_info_array_t? = nil
    fileprivate var prev_cpu_info_cnt = mach_msg_type_number_t(0)
    
    public mutating func cpuUsage() -> Double {
        let cpu_cores = SysInfo.physicalCores()
        var num_cpu: natural_t = 0
        var cpu_info_list: processor_info_array_t? = nil
        var cpu_info_cnt = mach_msg_type_number_t(0)
        _ = withUnsafeMutablePointer(to: &cpu_info_list) {
            return $0.withMemoryRebound(to: processor_info_array_t?.self, capacity: 1) {
                host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &num_cpu, $0, &cpu_info_cnt)
            }
        }
        
        var inuse_cpu:Double = 0
        var total_cpu:Double = 0
        for index in 0..<cpu_cores {
            var inuse: Int32 = 0
            var total: Int32 = 0
            if prev_cpu_info_list == nil {
                inuse = ((cpu_info_list?[4*index+0] ?? 0) - (prev_cpu_info_list?[4*index+0] ?? 0)) +
                    ((cpu_info_list?[4*index+1] ?? 0) - (prev_cpu_info_list?[4*index+1] ?? 0)) +
                    ((cpu_info_list?[4*index+3] ?? 0) - (prev_cpu_info_list?[4*index+3] ?? 0))
                total = inuse + ((cpu_info_list?[4*index+2] ?? 0) - (prev_cpu_info_list?[4*index+2] ?? 0))
            } else {
                inuse = (cpu_info_list?[4*index+0] ?? 0) + (cpu_info_list?[4*index+1] ?? 0) + (cpu_info_list?[4*index+3] ?? 0)
                total = inuse + (cpu_info_list?[4*index+2] ?? 0)
            }
            
            inuse_cpu += Double(inuse)
            total_cpu += Double(total)
        }
        
        if prev_cpu_info_list == nil {
            let prevCpuInfoSize = UInt32(UInt32(MemoryLayout<integer_t>.size) * UInt32(prev_cpu_info_cnt))
            vm_deallocate(mach_host_self(), vm_address_t(UInt(bitPattern: prev_cpu_info_list)), vm_size_t(prevCpuInfoSize))
        }
        
        self.prev_cpu_info_list = cpu_info_list
        self.prev_cpu_info_cnt = cpu_info_cnt
        
        return inuse_cpu / total_cpu
    }

    public func memoryUsage() -> (Int, Int) {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
            
        var used: Int = 0
        if result == KERN_SUCCESS {
            used = Int(taskInfo.phys_footprint)
        }
            
        let total = ProcessInfo.processInfo.physicalMemory
        return (used, Int(total))
    }
    
    public func gpuUsage() -> Float {
        return GPUChecker.gpuUsage()
    }

    public static func physicalCores() -> Int {
        return Int(SysInfo.hostBasicInfo().physical_cpu)
    }
    
    fileprivate static func hostBasicInfo() -> host_basic_info {
        var size     = UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)
        let hostInfo = host_basic_info_t.allocate(capacity: 1)
            
        _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_info(mach_host_self(), HOST_BASIC_INFO, $0, &size)
        }
      
        let data = hostInfo.move()
        hostInfo.deallocate()
            
        return data
    }
}
