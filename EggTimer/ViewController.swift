//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.


import UIKit
import AVFoundation

class ViewController: UIViewController {
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 700]
    var timer = Timer()
    
    var player: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        timer.invalidate()
        player?.stop()
        let hardness = sender.currentTitle!
        var totalTime = 0
        var secondsPassed = 0
        progressBar.progress = 0
        mainLabel.text = hardness
        
        totalTime = eggTimes[hardness]!
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] (Timer) in
            if secondsPassed < totalTime {
                secondsPassed += 1
                progressBar.progress = Float(secondsPassed) / Float(totalTime)
            } else {
                playSound()
                mainLabel.text = "Done!"
                timer.invalidate()
                self.mainLabel.alpha = 1;
                UIView.animate(withDuration: 0.5, delay: 0.3, options: [.repeat, .curveEaseOut, .autoreverse], animations: {
                    self.mainLabel.alpha = 0;
                }, completion: nil)
            }
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

