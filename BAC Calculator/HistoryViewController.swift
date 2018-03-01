//
//  HistoryViewController.swift
//  BAC Calculator
//
//  Created by Jacob Sokora on 3/1/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTable: UITableView!
    
    var bacs: [BACCalculation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.dataSource = self
        historyTable.delegate = self
        // Do any additional setup after loading the view.
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BACCalculation")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let results = try context.fetch(request)
            for data in results as! [BACCalculation] {
                bacs.append(data)
            }
        } catch {
            print("Failed to load data")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let bac = self.bacs.remove(at: indexPath.row)
            self.historyTable.reloadData()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(bac)
            success(true)
        }
        deleteAction.image = UIImage(named: "ic_delete")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bacs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTable.dequeueReusableCell(withIdentifier: "bacCell", for: indexPath)
        let bac = bacs[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.textLabel?.text = "\(formatter.string(from: bac.date!))"
        cell.detailTextLabel?.text = "\(round(bac.bac * 1000) / 1000)"
        return cell
    }
}
