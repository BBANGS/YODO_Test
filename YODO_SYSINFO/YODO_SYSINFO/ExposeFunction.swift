//
//  ExposeFunction.swift
//  YODO_SYSINFO
//
//  Created by Bokdung on 3/16/24.
//

import Foundation

@_cdecl("YODO_SYSINFO_runTracking")
public func YODO_SYSINFO_runTracking(callback: @escaping (Double, Float, UInt64) -> ()) {
    YODO_SYSINFO.runTracking(callback: callback)
}

@_cdecl("YODO_SYSINFO_stopTracking")
public func YODO_SYSINFO_stopTracking() {
    YODO_SYSINFO.stopTracking()
}
