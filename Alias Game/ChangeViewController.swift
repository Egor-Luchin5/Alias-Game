//
//  ChangeViewController.swift
//  Alias Game
//
//  Created by Егор Лукин on 10.07.2024.
//

import UIKit

class ChangeViewController: UIViewController {

    @IBOutlet weak var HardLevelView: UIView!
    @IBOutlet weak var EasyLevelView: UIView!
    @IBOutlet weak var MediumLevelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
 
    }

    @IBAction func BackButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SelectEasyLevelButtonPressed(_ sender: UIButton) {
        guard let gameController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        self.navigationController?.pushViewController(gameController, animated: true)
        gameController.selectLevelArray = EasyWords.shared.EasyWordsArray
    }
    
    
    @IBAction func SelectMiddleLevelButtonPressed(_ sender: UIButton) {
        guard let gameController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        self.navigationController?.pushViewController(gameController, animated: true)
        gameController.selectLevelArray = MiddleWords.shared.MiddleWordsArray
        
    }
    
    @IBAction func SelectHardLevelButtonPressed(_ sender: UIButton) {
        guard let gameController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        self.navigationController?.pushViewController(gameController, animated: true)
        gameController.selectLevelArray = HardWords.shared.HardWordsArray
    }
}
