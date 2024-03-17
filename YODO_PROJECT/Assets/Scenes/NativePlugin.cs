using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class NativePlugin : MonoBehaviour
{
    public delegate void DelegateCallback(double cpuusage, float gpuusage, uint memusage);
#if UNITY_IOS
    [DllImport("__Internal")]
    private static extern void YODO_SYSINFO_runTracking(DelegateCallback callback);

    [DllImport("__Internal")]
    private static extern void YODO_SYSINFO_stopTracking();
#endif

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public static void StartTracking(DelegateCallback callback) {
#if UNITY_IOS
        YODO_SYSINFO_runTracking(callback);
#endif
    }

    public static void StopTracking()
    {
#if UNITY_IOS
        YODO_SYSINFO_stopTracking();
#endif
    }
}
