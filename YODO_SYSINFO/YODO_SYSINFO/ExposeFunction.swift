//
//  ExposeFunction.swift
//  YODO_SYSINFO
//
//  Created by Bokdung on 3/16/24.
//

import Foundation

@_cdecl("YODO_SYSINFO_runTracking")
public func YODO_SYSINFO_runTracking(callback: @convention(c) @escaping (Double, Float, Int) -> Void) {
    YODO_SYSINFO.runTracking(callback: callback)
}

@_cdecl("YODO_SYSINFO_stopTracking")
public func YODO_SYSINFO_stopTracking() {
    YODO_SYSINFO.stopTracking()
}
