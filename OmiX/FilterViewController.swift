//
//  FilterViewController.swift
//  OmiX
//
//  Created by Monsurat Olaosebikan on 6/17/19.
//  Copyright © 2019 Wellesley HCI. All rights reserved.
//

import UIKit



class FilterViewController: UITableViewController {
    
    @IBOutlet weak var tableHeader: UIView!
    
    let sections = ["Types", "Risk Factors"]
//    let filters = [
//        ["Identification", "Detection", "Composition"],
//        ["E coli", "Dustmites", "Gluten", "Pollen"]
//    ]
    
    let filters = ["surfaces",
                   "objects",
                   "pollen",
                   "e coli",
                   "dustmites",
                   "peanut",
                   "shellfish",
                   "wheat",
                   "gluten",
                   "mold",
                   "fish"]

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.tableHeaderView = tableHeader
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filters[section].count
        return filters.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        return self.sections.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let name = filters[indexPath.section][indexPath.row]
        let name = filters[indexPath.row]
        cell.textLabel?.text = name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        if (StateController.shared.filters[name.lowercased()] == true) {
//            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
//        } else {
//            cell.accessoryType = UITableViewCell.AccessoryType.none
//        }
        
        if (StateController.shared.filters.contains(name.lowercased())) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//            let index = filters[indexPath.section][indexPath.row].lowercased()
            let index = filters[indexPath.row].lowercased()
//            StateController.shared.filters[index] = false
            StateController.shared.filters.remove(index)

        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            let index = filters[indexPath.section][indexPath.row].lowercased()
            let index = filters[indexPath.row].lowercased()
//            StateController.shared.filters[index] = true
            StateController.shared.filters.insert(index)
        }
    }
    
    //Header customization
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
//
//        let label = UILabel()
//        label.text = sections[section]
//        label.frame = CGRect(x: 19, y: 10, width: 300, height:35)
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        view.addSubview(label)
//
//        //creating the "select all" and "deselect all" button for each section header
//        let selectButton: UIButton = UIButton(frame: CGRect(x: 220, y: 10, width: 200, height: 35))
//
//        //using the boolean to check if all buttons are selected for each section
//        selectButton.tag = section          //buttons' tags will be '0' and '1'
//        if(StateController.shared.allSelected[selectButton.tag] == true) {
//            selectButton.setTitle("Deselect all", for: .normal)
//        } else {
//            selectButton.setTitle("Select all", for: .normal)
//        }
//
//        selectButton.addTarget(self, action: #selector(buttonAction),for: .touchUpInside)
//        selectButton.setTitleColor(UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0), for: .normal)
//        view.addSubview(selectButton)
//
//        return view
//    }
    
//    @IBAction func buttonAction(sender: UIButton!) {
//
//        if(sender.titleLabel?.text == "Select all") {
//            sender.setTitle("Deselect all", for: .normal)
//            StateController.shared.allSelected[sender.tag] = true
//            for row in 0..<3 {
//                let index = IndexPath(row: row, section: sender.tag)        //ex. [0, 1] for 'Detection'
//                let filter = filters[sender.tag][row].lowercased()
//                StateController.shared.filters[filter] = true
//                tableView.cellForRow(at: index)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//            }
//        }
//        else
//        {
//            sender.setTitle("Select all", for: .normal)
//            StateController.shared.allSelected[sender.tag] = false
//            for row in 0..<3 {
//                let index = IndexPath(row: row, section: sender.tag)
//                let filter = filters[sender.tag][row].lowercased()
//                StateController.shared.filters[filter] = false
//                tableView.cellForRow(at: index)?.accessoryType = UITableViewCell.AccessoryType.none
//            }
//        }
//    }
}
