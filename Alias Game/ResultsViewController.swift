//
//  ResultsViewController.swift
//  Alias Game
//
//  Created by Егор Лукин on 10.07.2024.
//

import UIKit

class ResultsViewController: UIViewController{
    @IBOutlet weak var GuessedTableView: UITableView!
    @IBOutlet weak var MissedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GuessedTableView.dataSource = self
        GuessedTableView.delegate = self
        MissedTableView.dataSource = self
        MissedTableView.delegate = self
    }

    @IBAction func BackButtonPressed(_ sender: UIButton) {
        GussedAndMissed.shared.GuessedArray = []
        GussedAndMissed.shared.MissedArray = []
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ResultsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == GuessedTableView{
            return GussedAndMissed.shared.GuessedArray.count
        } else {
            return GussedAndMissed.shared.MissedArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordsTableViewCell", for: indexPath) as? WordsTableViewCell else {return WordsTableViewCell()}
        cell.textLabel?.font = UIFont(name: "Futura-Bold", size: 17)
        cell.textLabel?.textColor = .black
        if tableView == GuessedTableView{
            cell.textLabel?.text = GussedAndMissed.shared.GuessedArray[indexPath.row]
        } else {
            cell.textLabel?.text = GussedAndMissed.shared.MissedArray[indexPath.row]
        }
        return cell
    }
}
