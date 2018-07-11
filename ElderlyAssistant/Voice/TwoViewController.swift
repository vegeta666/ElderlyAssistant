//
//  TwoViewController.swift
//  OlderApp
//
//  Created by 段佳伟 on 2017/7/16.
//  Copyright © 2017年 段佳伟. All rights reserved.
//

import UIKit
import Speech   //导入第三方库
import AVFoundation //音视频

class TwoViewController: UIViewController,SFSpeechRecognizerDelegate,UITextViewDelegate,AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    //
    var isPlay:Bool = false
    let syntesizer = AVSpeechSynthesizer()
    
    var voice = AVSpeechSynthesisVoice.init(language: "zh-CN")
    var utterance = AVSpeechUtterance()
    
    
    
    //
    //定义语音识别处理对象
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh-CN"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?  //处理语音识别请求
    private var recognitionTask: SFSpeechRecognitionTask?   //语音识别结果
    private let audioEngine = AVAudioEngine()  //语音引擎，负责提供语音输入
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        microphoneButton.isEnabled = false
        
        speechRecognizer?.delegate = self as SFSpeechRecognizerDelegate
        microphoneButton.addTarget(self, action: #selector(microphoneTapped(sender:)), for:
            .touchUpInside)
        //用户反馈结果
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        //设置背景图片
        // self.view.layer.contents = UIImage(named:"Two1")?.cgImage
    }
    
    //播放
   
    @IBAction func play(_ sender: Any) {
        if !isPlay{
            let string = textView.text
            
            // 设置将要语音的文字
            utterance = AVSpeechUtterance(string:string!)
            //
            utterance.voice = voice
            // 语音的速度
            utterance.rate = 0.4
            // 开始朗读
            
            syntesizer.speak(utterance)
            play.setTitle("停止语音", for: UIControlState.normal)
            isPlay = true
            
        }else{
            syntesizer.stopSpeaking(at: .immediate)
            play.setTitle("播放语音", for: UIControlState.normal)
            isPlay = false
        }
    }
    
    
    
    @objc func microphoneTapped(sender: AnyObject) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setImage(UIImage(named:"button-play.png"), for: UIControlState.normal)
            microphoneButton.setTitle("开始录音", for: .normal)
        } else {
            startRecording()
            microphoneButton.setImage(UIImage(named:"button-pause.png"), for: UIControlState.normal)
            microphoneButton.setTitle("停止录音", for: .normal)
        }
    }
    ///////////
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode : AVAudioInputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "说点什么吧，我听着呢!"
        
    }
    ///////////////////////
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    //设置键盘事件
    @IBAction func backgroundTap(sender:UIControl){
        textView.resignFirstResponder()
    }
    
    
    
    
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

