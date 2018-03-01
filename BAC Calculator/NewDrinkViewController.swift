//
//  NewDrinkViewController.swift
//  BAC Calculator
//
//  Created by Jacob Sokora on 2/28/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class NewDrinkViewController: UIViewController {
    
    @IBOutlet weak var drinkTypeField: UITextField!
    @IBOutlet weak var contentField: UITextField!
    @IBOutlet weak var servingsField: UITextField!
    @IBOutlet weak var servingSizeField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    var parentView: CalculatorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drinkTypeField.loadDropdown(data: ["beer", "wine", "liqour"], nextField: contentField)
        servingSizeField.loadDropdown(data: ["can(s) (12 oz)", "pint(s) (16 oz)", "shot(s) (1.5 oz)", "glass(es) (5 oz)", "ounce(s)", "milliliters"], nextField: nil)
        contentField.text = "4.5"
        servingsField.text = "1"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createDrink(_ sender: UIButton) {
        guard let parent = parentView else {
            return
        }
        let type: DrinkType? = DrinkType(rawValue: self.drinkTypeField.text!)
        let content: Double? = Double(self.contentField.text!)
        let servings: Int? = Int(self.servingsField.text!)
        let description: String? = self.servingSizeField.text
        guard type != nil && content != nil && servings != nil && description != nil  else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please make sure all fields are entered correctly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: {() -> Void in
            parent.drinks.append(Drink(type!, content!, servings!, description!))
            parent.drinksTable.reloadData()
        })
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func drinkTypeChanged(_ sender: UITextField) {
        if let type = DrinkType(rawValue: sender.text!) {
            switch type {
            case .beer:
                servingSizeField.text = "can(s) (12 oz)"
                contentField.text = "4.5"
            case .wine:
                servingSizeField.text = "glass(es) (5 oz)"
                contentField.text = "12.5"
            case .liqour:
                servingSizeField.text = "shot(s) (1.5 oz)"
                contentField.text = "40"
            }
        }
    }
}

