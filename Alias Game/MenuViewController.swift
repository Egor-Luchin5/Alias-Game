//
//  MenuViewController.swift
//  Alias Game
//
//  Created by Егор Лукин on 10.07.2024.
//

import UIKit

class MenuViewController: UIViewController {
    var switchisenabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        LocalPushNotification()

    }

        @IBAction func StartGameButtonPressed(_ sender: UIButton) {
        guard let changeController = self.storyboard?.instantiateViewController(withIdentifier: "ChangeViewController") as? ChangeViewController else {return}
        self.navigationController?.pushViewController(changeController, animated: true)
    }

    @IBAction func OpenRulesButtonPressed(_ sender: UIButton) {
        guard let rulesController = self.storyboard?.instantiateViewController(withIdentifier: "RulesViewController") as? RulesViewController else {return}
        self.navigationController?.pushViewController(rulesController, animated: true)
    }
    func LocalPushNotification(){
        let center = UNUserNotificationCenter.current()
        //Запрашиваем авторизацию и разрешение на отправку уведомлений
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                //если разрешил. то супер
                print("Yay!")
            } else {
                //если не разрешил, то можно отправить alert о том что «вы не будете получать уведомления»
                print("D'oh")
            }
        }
        
        //обьект класса
        let content = UNMutableNotificationContent()
        content.title = "Alias Game"
        content.body = "Заскучали с друзьями? Тогда поскорей включай меня!"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "bluetoothIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

}
