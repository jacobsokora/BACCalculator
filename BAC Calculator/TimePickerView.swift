//
//  TimePickerView.swift
//  BAC Calculator
//
//  Created by Jacob Sokora on 2/27/18.
//  Copyright © 2018 Jacob Sokora. All rights reserved.
//

import UIKit

class TimePickerView: UIDatePicker {

    var pickerTextField: UITextField!
    
    init(dropdownField: UITextField) {
        super.init(frame: CGRect.zero)
        self.pickerTextField = dropdownField
        self.datePickerMode = .countDownTimer
        self.addTarget(self, action: #selector(updateTime(sender:)), for: UIControlEvents.valueChanged)
        
        backgroundColor = .white
        
        let nextBar = UIToolbar()
        nextBar.barStyle = .default
        nextBar.isTranslucent = true
        nextBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        nextBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let spaceBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        nextBar.setItems([spaceBar, doneButton], animated: false)
        nextBar.isUserInteractionEnabled = true
        pickerTextField.inputAccessoryView = nextBar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateTime(sender: UIDatePicker) {
        var seconds = Int(sender.countDownDuration)
        let hours = seconds / 3600
        seconds -= hours * 3600
        let minutes = seconds / 60
        pickerTextField.text = "\(hours) \(hours == 1 ? "hour" : "hours") \(minutes) \(minutes == 1 ? "minute" : "minutes")"
    }
    
    @objc func done() {
        updateTime(sender: self)
        pickerTextField.resignFirstResponder()
    }

}
