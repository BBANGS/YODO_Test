using System.Collections;
using System.Collections.Generic;
using AOT;
using UnityEngine;
using UnityEngine.UI;
using TMPro;


public class MainView : MonoBehaviour {
    public TMP_Text overlay_text_;
    public Button start_tracking_btn_;
    public Button stop_tracking_btn_;

    public static string overlay_text_val_;
    
    void Start() {
        overlay_text_val_ = "Tracking is Standby";
        if (start_tracking_btn_ ) {
            start_tracking_btn_.onClick.AddListener(OnStartTrackingBtnClick);
        }
        if (stop_tracking_btn_) {
            stop_tracking_btn_.onClick.AddListener(OnStopTrackingBtnClick);
        }
    }

    void Update() {
        overlay_text_.text = overlay_text_val_;
    }

    [MonoPInvokeCallback(typeof(NativeHandler.DelegateCallback))]
    static void TrackingCallback(double cpuusage, float gpuusage, int memusage) {
        double mem_mb = (double)memusage / 10000000;
        overlay_text_val_ = string.Format("SYSINFO\nCPU : {0:0.00}\nGPU : {1:0.00}\nMEM : {2:0.00}",
            cpuusage, gpuusage, mem_mb);
    }

    public void OnStartTrackingBtnClick() {
        NativeHandler.StartTracking(TrackingCallback);
        overlay_text_val_ = "Tracking is Start";
    }

    public void OnStopTrackingBtnClick() {
        NativeHandler.StopTracking();
        overlay_text_val_ = "Tracking is Stop";
    }
}
