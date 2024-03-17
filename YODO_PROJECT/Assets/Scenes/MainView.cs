using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using TMPro;
using UnityEngine.UI;

public class MainView : MonoBehaviour
{
    public TMP_Text overlay_text_;
    public Button start_tracking_btn_;
    public Button stop_tracking_btn_;

    // Start is called before the first frame update
    void Start()
    {
        overlay_text_.text = "Tracking is Standby";
        if(start_tracking_btn_) {
            start_tracking_btn_.AddListener(OnStartTrackingBtnClick);
        }
        if (stop_tracking_btn_)
        {
            stop_tracking_btn_.AddListener(OnStopTrackingBtnClick);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public static void TrackingCallback(double cpuusage, float gpuusage, uint memusage) {

    }

    public void OnStartTrackingBtnClick() {
        //NativePlugin.StartTracking(TrackingCallback);
        overlay_text_.text = "Tracking is Start";
    }

    public void OnStopTrackingBtnClick() {
        //NativePlugin.StopTracking();
        overlay_text_.text = "Tracking is Stop";
    }
}
