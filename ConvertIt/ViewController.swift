//
//  ViewController.swift
//  ConvertIt
//
//  Created by Charles Haynes on 5/27/18.
//  Copyright © 2018 KHH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var unitConverterStackView: UIStackView!
    @IBOutlet weak var utcStackView: UIStackView!
    @IBOutlet weak var convertFromField: UITextField!
    @IBOutlet weak var convertToField: UITextField!
    @IBOutlet weak var convertFromLabel: UILabel!
    @IBOutlet weak var convertToLabel: UILabel!
    @IBOutlet weak var utcLabel: UILabel!
    
    
    var convertFromPickerView = UIPickerView()
    var convertToPickerView = UIPickerView()
    
    let areaUnits = ["square meter" : 1.0, "square inch" : 1550, "square kilometer" : 0.000001, "square foot" : 10.7639 ]
    var pickerViewKeys = [String]()
    var convertValueStr: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        setupUi()
        
    }

    func setupUi() {
        
        utcStackView.isHidden = true
        unitConverterStackView.isHidden = true
        
        //updateUTCStack()
        updateUnitConverterStack()
    }
    
    func updateUTCStack() {
        utcStackView.isHidden = false
    }
    
    func updateUnitConverterStack() {
        
        unitConverterStackView.isHidden = false
        
        //Fill Array for picker views
        pickerViewKeys = Array(areaUnits.keys)
        
        //assign delegetes to self
        convertToPickerView.delegate = self
        convertToPickerView.dataSource = self
        convertFromPickerView.delegate = self
        convertFromPickerView.dataSource = self
        
        convertFromField.inputView = convertFromPickerView
        convertToField.inputView = convertToPickerView
        
        //Set the default conversion
        convertFromField.text = pickerViewKeys.first
        convertToField.text = pickerViewKeys.last
        convertValueStr = "0"
        calculateConvertedUnits()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func calculateConvertedUnits() {
        
        guard let convertFromValue = Double(convertValueStr),
            let convertFromCoefficient = areaUnits[convertFromField.text!],
            let convertToCoefficient = areaUnits[convertToField.text!] else {
                fatalError("Crash")
        }
        
        let baseUnit = convertFromValue / convertFromCoefficient
        
        let convertToValue = baseUnit * convertToCoefficient
        
        convertFromLabel.text = String(convertFromValue)
        convertToLabel.text = String(convertToValue)
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == convertFromPickerView {
            return pickerViewKeys.count
        } else {
            return pickerViewKeys.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == convertFromPickerView {
            return pickerViewKeys[row]
        } else {
            return pickerViewKeys[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == convertFromPickerView {
            convertFromField.text = pickerViewKeys[row]
            convertFromField.resignFirstResponder()
        } else {
            convertToField.text = pickerViewKeys[row]
            convertToField.resignFirstResponder()
        }
        
        calculateConvertedUnits()
    }
    
    @IBAction func onConvertButtonSelected(_ sender: UIButton) {
        if let buttonValueString = sender.title(for: UIControlState.normal) {
            if buttonValueString == "Back" {
                //Only remove if the string is not empty
                if(convertValueStr != "") {
                    convertValueStr.removeLast()
                }
            } else if buttonValueString == "." {
                if !convertValueStr.contains(buttonValueString) {
                    convertValueStr.append(buttonValueString)
                }
            } else {
                convertValueStr.append(buttonValueString)
            }
        }
        calculateConvertedUnits()
    }
    
    
}

