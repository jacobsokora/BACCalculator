//
//  CalculatorViewController.swift
//  BAC Calculator
//
//  Created by Jacob Sokora on 2/27/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit
import CoreData

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var rateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var drinksTable: UITableView!
    
    var drinks: [Drink] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        genderField.loadDropdown(data: ["male", "female"], nextField: rateField)
        rateField.loadDropdown(data: [
            "Cheap Date", "Social Drinker", "Frequent Drinker",
            "Heavy Drinker", "Frat Boy"], nextField: timeField)
        timeField.inputView = TimePickerView(dropdownField: timeField)
        drinksTable.dataSource = self
        drinksTable.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        let weight: Int? = Int(weightField.text!)
        let gender: String? = genderField.text
        let time: Double = getHours()
        if let weight = weight, let gender = gender, drinks.count != 0 {
            //.8 grams/mL
            var alcoholInGrams: Double = 0
            let weightInGrams: Double = Double(weight) * 453.592
            for drink in drinks {
                let milliliters: Double = drink.description == "milliliters" ? Double(drink.count) : (getOunces(from: drink) * 29.5735) * Double(drink.count)
                alcoholInGrams += (milliliters * drink.content / 100) * 0.8
            }
            let genderConstant = gender == "male" ? 0.68 : 0.55
            let metabolicRate = getMetabolicRate()
            var bac = ((alcoholInGrams / (weightInGrams * genderConstant)) * 100) - (metabolicRate * time)
            if bac < 0 {
                bac = 0
            }
            let drivable = bac < 0.08 ? 0 : round((bac - 0.08) / metabolicRate * 100) / 100
            let sober = round(bac / metabolicRate * 100) / 100
            let alert = UIAlertController(title: "Blood Alcohol Content", message: "Your blood alcohol content is: \(round((1000*bac)) / 1000). You will be able to drive in approximately \(drivable) hours and sober in approximately \(sober) hours", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action) in
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "BACCalculation", in: context)
                let data = BACCalculation(entity: entity!, insertInto: context)
                data.bac = bac
                data.date = Date()
                do {
                    try context.save()
                } catch {
                    print("Failed to save data")
                }
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please make sure all fields are entered correctly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func getMetabolicRate() -> Double {
        guard let rateString = rateField.text else {
            return 0
        }
        switch rateString {
        case "Cheap Date":
            return 0.01
        case "Social Drinker":
            return 0.17
        case "Frequent Drinker":
            return 0.02
        case "Heavy Drinker":
            return 0.03
        case "Frat Boy":
            return 0.04
        default:
            return 0.0
        }
    }
    
    func getOunces(from drink: Drink) -> Double {
        do {
            let regex = try NSRegularExpression(pattern: "(\\d+\\.?\\d*?) oz")
            let text = drink.description
            let results = regex.matches(in: text, range: NSRange(location: 0, length: text.count))
            if let match = results.first {
                let ozRange = match.range(at: 1)
                return Double((text as NSString).substring(with: ozRange)) ?? 0
            }
        } catch {}
        return 0
    }
    
    func getHours() -> Double {
        do {
            let regex = try NSRegularExpression(pattern: "(\\d+) hours? (\\d+) minutes?")
            let text = timeField.text ?? "0 hours 1 minutes"
            let results = regex.matches(in: text, range: NSRange(location: 0, length: text.count))
            if let match = results.first {
                let hoursRange = match.range(at: 1)
                guard let hours = Int((text as NSString).substring(with: hoursRange)) else {
                    return 0.0
                }
                let minutesRange = match.range(at: 2)
                guard let minutes = Int((text as NSString).substring(with: minutesRange)) else {
                    return Double(hours)
                }
                return Double(minutes >= 30 ? hours + 1 : hours)
            }
        } catch {}
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = segue.destination as? NewDrinkViewController {
            sender.parentView = self
        }
    }
    
}

extension CalculatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)
        let drink = drinks[indexPath.row]
        cell.textLabel?.text = "\(drink.content)% \(drink.type)"
        cell.detailTextLabel?.text = "\(drink.count) \(drink.description)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
}

extension CalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.drinks.remove(at: indexPath.row)
            self.drinksTable.reloadData()
            success(true)
        }
        deleteAction.image = UIImage(named: "ic_delete")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

class Drink {
    var type: DrinkType = .beer
    var content: Double = 4.5
    var count: Int = 1
    var description: String = "can"
    
    init(_ type: DrinkType, _ content: Double, _ count: Int, _ description: String) {
        self.type = type
        self.content = content
        self.count = count
        self.description = description
    }
}

enum DrinkType: String {
    case beer
    case wine
    case liqour
}

