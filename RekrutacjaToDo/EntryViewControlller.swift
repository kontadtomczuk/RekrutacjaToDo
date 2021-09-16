//
//  EntryViewControlllerViewController.swift
//  RekrutacjaToDo
//
//  Created by Konrad Tomczuk on 15/09/2021.
//
import RealmSwift
import UIKit

class EntryViewControlller: UIViewController, UITextFieldDelegate {

    @IBOutlet  var textField: UITextField!
    @IBOutlet  var datePicker: UIDatePicker!
    @IBOutlet  weak var segmentedControl:
    UISegmentedControl!
    private let realm = try! Realm()
    public var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        textField.becomeFirstResponder()
        textField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Zapisz", style: .done, target: self, action: #selector(didTapSaveButton))
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func didTapSaveButton(){
        
        if let text = textField.text, !text.isEmpty {
            let date = datePicker.date
            
            var tekst = ""
            switch segmentedControl.selectedSegmentIndex {
            case 0: tekst = "Zakupy"
            case 1: tekst = "Praca"
            case 2: tekst = "Inne"
            default: tekst = "Inne";
            }
                
            realm.beginWrite()
            
            let newItem = ToDoListItem()
            newItem.deadline = date
            newItem.item = text
            newItem.category = tekst
            realm.add(newItem)
            try! realm.commitWrite()
            
            completionHandler?()
            navigationController?.popToRootViewController(animated: true)
        }
            else {
                        
                    let alert = UIAlertController(title: "Błąd", message: "Pola nie zostały poprawnie wypełnione.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
    }
}

