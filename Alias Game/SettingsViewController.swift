//
//  SettingsViewController.swift
//  Alias Game
//
//  Created by Егор Лукин on 10.07.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    static let shared = SettingsViewController()
    
    
    @IBOutlet weak var SoundSwitch: UISwitch!
    @IBOutlet weak var TextField: UITextField!
    let picker = UIImagePickerController()
    var Timerkey = UserDefaults.standard.integer(forKey: "countOfTimer")
    var state = UserDefaults.standard.bool(forKey: "SoundState")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        RemoveTheKeyboard()
        RemoveKeyboard()
        SoundSwitch.isOn = state
    }
    @IBAction func ChangeValueSoundSwitch(_ sender: UISwitch) {
        UserDefaults.standard.setValue(SoundSwitch.isOn, forKey: "SoundState")
        NotificationCenter.default.post(name: NSNotification.Name("SoundSwitch"), object: SoundSwitch.isOn)

    }
    
    @IBAction func ChangeCountOfTimerTextField(_ sender: UITextField) {
        NotificationCenter.default.post(name: Notification.Name("ChangeTimerCount"), object: sender.text)
        UserDefaults.standard.set(sender.text, forKey: "countOfTimer")
    }

    @IBAction func ChangeBackgroundDefaultButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("DefaultBackground"), object: nil)
        self.dismiss(animated: true)
    }
    @IBAction func ChangeBackgroundImageButtonPressed(_ sender: UIButton) {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("showAlertSave"), object: nil)
        
    }
    
    private func RemoveTheKeyboard(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(RemoveKeyboard))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
    }
    @IBAction func RemoveKeyboard(){
        self.TextField.resignFirstResponder()
    }
    
}

extension SettingsViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.TextField.resignFirstResponder()
        return true
    }
}

extension SettingsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var chosenImage = UIImage()
        
        //Проверяем, изменен ли размер выбранной фотографии
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = image
        }
        //Добавляем в ImageView нашу выбранную(редактированную) фотографию
        NotificationCenter.default.post(name: Notification.Name("Image"), object: chosenImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
}
