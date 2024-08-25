//
//  GameViewController.swift
//  Alias Game
//
//  Created by Егор Лукин on 10.07.2024.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    static let shared = GameViewController()
    var player: AVAudioPlayer?

    //MARK: - Outlet's

    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var CountGuessedLabel: UILabel!
    @IBOutlet weak var CountMissedLabel: UILabel!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var BackgroundImageView: UIImageView!
    
    //MARK: - Var and let
    
    var countGuessed = 0
    var countMissed = 0
    var countOfTimer = 30
    var soundOfSwitchisEnabled:Bool = SettingsViewController.shared.state
    
    var selectLevelArray:[String] = []

    var timer = Timer()
    let myView = UIView()
    let myAlertView = UIView()
    let myAlertLabel = UILabel()
    var myLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        
        BackgroundImageView.addParalaxEffect()
        LoadSettings()
        CreatView()
        showAlertView()
        
        self.myView.isHidden = true
        self.myLabel.isHidden = true
        
        self.TimerLabel.text = "\(countOfTimer)"

        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(AnimationMyviewUp))
        swipeUp.direction = .up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(AnimationMyviewDown))
        swipeDown.direction = .down
        
        self.myView.addGestureRecognizer(swipeUp)
        self.myView.addGestureRecognizer(swipeDown)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        PauseButton.isHidden = true
        soundOfSwitchisEnabled = SettingsViewController.shared.state
        self.TimerLabel.text = "\(countOfTimer)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeImage), name: NSNotification.Name("Image"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeDefaultImage), name: NSNotification.Name("DefaultBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeValueSoundSwitch(_:)), name: NSNotification.Name("SoundSwitch"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showandhidealertmyview), name: Notification.Name("showAlertSave"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeTimerCount), name: Notification.Name("ChangeTimerCount"), object: nil)
        
    }

    
    @objc func ChangeImage(_ notification: Notification){
        BackgroundImageView.image = notification.object as? UIImage

    }
    @objc func ChangeValueSoundSwitch(_ notification: Notification){
        soundOfSwitchisEnabled = notification.object as! Bool
    }
    @objc func ChangeTimerCount(_ notification: Notification){
        TimerLabel.text = notification.object as? String
        print(notification.object ?? 10)
    }
    @objc func changeDefaultImage(){
        BackgroundImageView.image = UIImage(named: "background")
    }
    
    
    //MARK: - Back Button
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Audio
    
    func playSound(name:String) {
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url)
                if let player = player {
                    player.play()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }

    
    //MARK: - CreatView
    func CreatView(){
        myView.frame = CGRect(x: (view.frame.width / 2) - 100, y: (view.frame.height / 2) - 100, width: 200, height: 200)
        
        myView.layer.cornerRadius = 100
        myView.backgroundColor = .white
        
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.8
        myView.layer.shadowOffset = CGSize(width: 0, height: 0)
        myView.layer.shadowRadius = 5
        
        myLabel.frame = CGRect(x: (myView.frame.width / 2) - 75, y: (myView.frame.height / 2) - 25, width: 150, height: 50)
        
        myLabel.font = UIFont(name: "Impact", size: 20)
        myLabel.textAlignment = .center
        
        myLabel.text = selectLevelArray.randomElement()
        myLabel.text = self.selectLevelArray.randomElement()
        myLabel.textColor = .black
        myLabel.numberOfLines = 0
        myLabel.lineBreakMode = .byWordWrapping
        myLabel.preferredMaxLayoutWidth = myLabel.frame.width
        
        self.myView.addSubview(myLabel)
        self.view.addSubview(myView)
    }
    
    func showAlertView(){
        myAlertView.frame = CGRect(x: (view.frame.width / 2) - 150, y: view.frame.height, width: 300, height: 100)
        myAlertLabel.frame = CGRect(x: myAlertView.frame.width / 2 - 100 , y: myAlertView.frame.height / 2 - 25, width: 200, height: 50)
        myAlertView.backgroundColor = .white
        myAlertView.layer.cornerRadius = 20
        myAlertLabel.text = "Изменения сохранены"
        myAlertLabel.textColor = .black
        myAlertLabel.font = UIFont(name: "Impact", size: 18)
        myAlertView.addSubview(myAlertLabel)
        view.addSubview(myAlertView)
    }
    @objc func showandhidealertmyview(){
        TimerCounter()
        UIView.animate(withDuration: 0.75) {
            self.myAlertView.frame.origin.y -= 150
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            // Ваш код, который будет выполняться спустя 3 секунды
            UIView.animate(withDuration: 0.5) {
                self.myAlertView.frame.origin.y += 150
            }
        }
    }
    
    //MARK: - Animations Swipe
    @IBAction func AnimationMyviewDown(){
        UIView.animate(withDuration: 0.5) {
            self.myView.frame.origin.y += 100
            self.myView.alpha = 0
        } completion: { _ in
            self.myView.frame.origin.y -= 100
            self.myView.alpha = 1
            
            GussedAndMissed.shared.MissedArray.append(self.myLabel.text!)
            
            self.myLabel.text = self.selectLevelArray.randomElement()
        }
        if soundOfSwitchisEnabled {
            playSound(name: "swipe")
        }
        CounterMissed()
        
    }

    
    @IBAction func AnimationMyviewUp(){
        UIView.animate(withDuration: 0.5) {
            self.myView.frame.origin.y -= 100
            self.myView.alpha = 0
        } completion: { _ in
            self.myView.frame.origin.y += 100
            self.myView.alpha = 1
            
            GussedAndMissed.shared.GuessedArray.append(self.myLabel.text!)
            self.myLabel.text = self.selectLevelArray.randomElement()
        }
        if soundOfSwitchisEnabled {
            playSound(name: "swipe")
        }
        CounterGuessed()
    }
    
    //MARK: - Counters function
    private func CounterGuessed(){
        countGuessed += 1
        CountGuessedLabel.text = String(countGuessed)
    }
    private func CounterMissed(){
        countMissed += 1
        CountMissedLabel.text = String(countMissed)
    }
    
    //MARK: - Load Settings
    func LoadSettings(){
        guard let settingsController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}
        self.countOfTimer = settingsController.Timerkey
    }
    
    //MARK: - Start Button
    @IBAction func StartButtonPressed(_ sender: UIButton) {
        if soundOfSwitchisEnabled {
            playSound(name: "button")
        }
        guard let settingsController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}
        
        self.myView.isHidden = false
        self.myLabel.isHidden = false
        self.StartButton.isHidden = true

        if self.countOfTimer == 0 {
            countOfTimer = settingsController.Timerkey
        }
        TimerCounter()
        PauseButton.isHidden = false
    
    }
    
    
    //MARK: - Pause Button
    @IBAction func PauseButtonPressed(_ sender: UIButton) {
        if soundOfSwitchisEnabled {
            playSound(name: "button")
        }

        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true{
            if countOfTimer > 0 {
                self.timer.invalidate()
            } else if countOfTimer < 0 {
                return
            }
        } else if sender.isSelected == false {
            self.TimerCounter()
            
        }
    }
    
    //MARK: - Timer function
    func TimerCounter(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if self.countOfTimer == 0{
                self.countOfTimer = 10
            } else{
                self.countOfTimer -= 1
                
            }
            self.TimerLabel.text = "\(self.countOfTimer)"
            
            if self.countOfTimer == 0 {
                
                self.myView.isHidden = true
                self.myLabel.isHidden = true
                
                self.OpenResults()
                self.timer.invalidate()
                self.StartButton.isHidden = false
            }
            
            if self.countOfTimer == 3{
                if self.soundOfSwitchisEnabled {
                    self.playSound(name: "timer")
                }
            }
            
        })
        
        
    }
    @IBAction func OpenSettingsButtonPressed(_ sender: UIButton) {
        guard let settingController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}
        self.present(settingController, animated: true)
        timer.invalidate()
        
    }
    
    private func OpenResults(){
        self.countGuessed = 0
        self.countMissed = 0
        self.CountGuessedLabel.text = "0"
        self.CountMissedLabel.text = "0"
        guard let resultsController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController else { return }
        self.navigationController?.pushViewController(resultsController, animated: true)
    }
    //MARK: - UiSwitch

}

//MARK: - Extension

extension UIView {
    func addParalaxEffect(amount: Int = 20) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
}
