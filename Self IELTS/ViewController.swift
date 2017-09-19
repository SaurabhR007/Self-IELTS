//
//  ViewController.swift
//  Self IELTS
//
//  Created by Saurabh TheRockStar on 18/09/17.
//  Copyright © 2017 saurabhrode@gmail.com. All rights reserved.
//

import UIKit

import AVFoundation


import TGCircularTimerView

class ViewController: UIViewController, TGCircularTimerViewDelegate {
    
    @IBOutlet weak var timer: TGCircularTimerView!
 
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    public  var addTimeDuration:Double!
    
    var loopAttempts = 1;
    
    
    
    var player: AVAudioPlayer?
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer.duration = addTimeDuration * 60.0;
        timer.delegate = self
        startButton.setTitle("Start", for: UIControlState())
        
        UIApplication.shared.isIdleTimerDisabled = true
      
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
//    func addTimeDuration(addTimeDuration:Double){
//        
//        self.addTimeDuration = addTimeDuration
//    }
    // MARK - IBActions
    
 
    
    @IBAction func didTapStartStopButton(_ sender: UIButton) {
        if !timer.counting {
            timer.start()
        } else {
            timer.pause()
        }
    }
    @IBAction func cancelTestButtonClicked(_ sender: Any) {
        
        timer.reset()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapResetButton(_ sender: UIButton) {
        timer.reset()
    }
    
    
    
    // MARK - TGCircularTimerViewDelegate
    
    func timerHasFinished(_ timer: TGCircularTimerView) {
        
        playSound()
        let alert = UIAlertController(title: "Done!", message: "Timer finished 🎯 for \(loopAttempts) attempt", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK 😃", style: .default, handler: { (sender) in
            self.stopSound()
            self.dismiss(animated: true, completion: nil)
            self.loopAttempts = 0
          
           
        }))
        
        alert.addAction(UIAlertAction(title: "I am yet to finish 😮", style: .default, handler: { (sender) in
            self.stopSound()
            let addDuration = timer.duration
            timer.duration = addDuration
            timer.start()
            self.loopAttempts+=1
           
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        startButton.setTitle("Start", for: UIControlState())
    }
    
    func finsishedBeforeTimeAlert(_ timer: TGCircularTimerView) {
        
        let alert = UIAlertController(title: "Are you sure ?", message: "In \(loopAttempts) attempt before the time 😃", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yea  ❤️", style: .default, handler: { (sender) in
            timer.reset()
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "I pressed by mistake 😐", style: .default, handler: { (sender) in
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func timerHasPaused(_ timer: TGCircularTimerView) {
        
        finsishedBeforeTimeAlert(timer)
        startButton.setTitle("Continue", for: UIControlState())
    }
    
    func timerHasStarted(_ timer: TGCircularTimerView) {
      
        startButton.setTitle("I am Done!", for: UIControlState())
        
    }
    
    func timerHasBeenReset(_ timer: TGCircularTimerView) {
      
        startButton.setTitle("Start", for: UIControlState())
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "stopAlaram", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound(){
        player?.stop()
    }
}


