//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by  lama almarshad on 08/09/2019.
//  Copyright © 2019  lama almarshad. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear Called")
    }
    
    func enabling (recording : Bool){
        if recording {
        recordingLabel.text="Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        }
        else {
            recordingLabel.text = "Tap To Record"
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        enabling (recording : true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath)fileURLWithPath
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try!  audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        if audioRecorder.isRecording{   
        }
        else{
        audioRecorder.record()
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        enabling (recording : false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "Stop Recording", sender: audioRecorder.url)
        }
        else{
            print("Recording was not successfull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordign" {
          let playSoundsVC = segue.destination as! PlaySoundsViewController
          let recordedAudioURL = sender as! URL
          playSoundsVC.recordedAudioURL = recordedAudioURL
        }
        
    }
    
}

