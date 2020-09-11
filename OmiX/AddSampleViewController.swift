//
//  AddSampleViewController.swift
//  OmiX
//
//  Created by WellesleyHCI Lab11 on 6/13/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}

class AddSampleViewController: UITableViewController {
    let url = Bundle.main.url(forResource: "samples", withExtension: "json")!
    var samples = [Datum]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        getSamples()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    func getSamples() {
        do {
            let jsonData = try Data(contentsOf: url)
            self.samples = try! JSONDecoder().decode(Samples.self, from: jsonData).data
            self.tableView.reloadData()
            
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeadlineTableViewCell
        cell.nameLabel?.text = samples[indexPath.row].name
        cell.nameLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.nameLabel?.adjustsFontSizeToFitWidth = true
        
        cell.locationLabel?.text = samples[indexPath.row].location
        cell.locationLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.locationLabel?.adjustsFontSizeToFitWidth = true
        
        cell.dateLabel?.text = samples[indexPath.row].date
        cell.dateLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.dateLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    //not relevant
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }

        dismiss(selection: samples[indexPath.row])
    }
    
    func dismiss(selection: Datum) {
        StateController.shared.selectedSample = selection
        self.dismiss(animated: true, completion: nil)
    }
}
