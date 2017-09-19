//
//  Tab2ViewController.swift
//  Self IELTS
//
//  Created by Saurabh TheRockStar on 18/09/17.
//  Copyright © 2017 saurabhrode@gmail.com. All rights reserved.
//hgUgWxEUDfCr8ND3





import UIKit

class Tab2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate {
    
    @IBOutlet weak var sectionTableView: UITableView!
    
    @IBOutlet weak var addDurationTf: UITextField!
    
    @IBOutlet weak var addFirstQuetionTF: UITextField!
    
    @IBOutlet weak var addLastQuetionTF: UITextField!
    
    @IBOutlet weak var AddSectionLabel: UILabel!
    
    @IBOutlet weak var addListView:UIView!
    
    var addCounter = 0
    
    var addSections:Array? = [String] ();
    
    let sections = ["Sectiona A" ,"Sectiona B" ,"Sectiona C" ,"Sectiona D" ,"Sectiona E" ,"Sectiona F" ,"Sectiona G" ,"Sectiona H" ,"Sectiona I" ,"Sectiona J" ]
    var textFieldInputs: Array! = [[String:String]] ()

   
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Tab2ViewController.dismissKeyboard))
        addListView.addGestureRecognizer(tap)
       //  dataRequest()
    }
    
    @IBAction func addQuetionsInListButtonClicked(_ sender: Any) {
        
        addSections?.append(sections[addCounter])
      
        let addData:[String:String] = ["duration":  addDurationTf.text! , "indexPath":String(describing:IndexPath.init(item:addCounter, section:0))]
        textFieldInputs.append(addData)
        addCounter += 1
        
        if addCounter < sections.count {
           AddSectionLabel.text = sections[addCounter]
        }
        
        
      
        resetAddViewValues()
        sectionTableView.reloadData()
    }
    
    
    func resetAddViewValues(){
        
        addDurationTf.text = ""
        addLastQuetionTF.text=""
        addFirstQuetionTF.text = ""
        dismissKeyboard()
    }
    
    
    func dismissKeyboard(){
       
        view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  (addSections?.count)! > 0{
        
            return (addSections?.count)! + 1 ;
        
        }else{
            return 0;
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if(indexPath.row == addSections!.count){
            let cellID = "cell2"
            let cell:SubmitButtonTableViewCell = sectionTableView.dequeueReusableCell(withIdentifier: cellID) as! SubmitButtonTableViewCell
        
            return cell;
        }
        
          let cellID = "cell1"
          let cell:SectionsTableViewCell = sectionTableView.dequeueReusableCell(withIdentifier: cellID) as! SectionsTableViewCell
          cell.sectionTF?.text = addSections![indexPath.row]
          cell.durationTF?.delegate = self as Tab2ViewController
          cell.startingQuetionTF?.delegate = self as Tab2ViewController
          cell.durationTF?.tag = 100
          cell.startingQuetionTF?.tag = 200
          let values = valueAvailableInArrayOrNot(indexPath: indexPath)
          cell.durationTF?.text = values.0
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Tab2ViewController.dismissKeyboard))
          cell.contentView.addGestureRecognizer(tap)
        
          return cell;
    }
    
    func valueAvailableInArrayOrNot(indexPath:IndexPath) -> (String, Int){
        
        if textFieldInputs.count > 0 {
            
            for (index,element) in textFieldInputs.enumerated(){
                
                if element["indexPath"] == String(describing: indexPath) {
                    
                    return (element["duration"]!,index)
                }
            }
            
        }
        
        return ("",-1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        if(indexPath.row == addSections!.count){
            dismissKeyboard()
            presentVC()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if(indexPath.row == addSections!.count){
        
            return 32.0
        }
        return 93.0
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("%@",textField.text!)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let center: CGPoint = textField.center
        let rootViewPoint: CGPoint = textField.superview!.convert(center, to: sectionTableView)
        let indexPath: IndexPath? = sectionTableView.indexPathForRow(at: rootViewPoint)
        print("\(String(describing: indexPath))")
        
        if (textField.text != nil)  && (!(textField.text?.isEmpty)!){
            let values = valueAvailableInArrayOrNot(indexPath: indexPath!)
            
            if values.1 > -1 {
                textFieldInputs.remove(at: values.1)
                let addData:[String:String] = ["duration":  textField.text! , "indexPath":String(describing: indexPath!)]
                textFieldInputs.append(addData)
            }
           
        }
    
        print("%@",textField.text!)
        return true
    }
    
    
    func presentVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "timerVC") as! ViewController
        var totalDuration:Double = 0.0
        for element in textFieldInputs {
          totalDuration = totalDuration +  Double(element["duration"]!)!
        }
        vc.addTimeDuration = totalDuration
        present(vc, animated: true, completion: nil)
    }
    
    
   
 
   
    
    
    



}
