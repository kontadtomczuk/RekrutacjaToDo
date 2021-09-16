//
//  ViewController.swift
//  RekrutacjaToDo
//
//  Created by Konrad Tomczuk on 15/09/2021.
//
import RealmSwift
import UIKit

class ToDoListItem: Object{
    @objc dynamic var item: String = ""
    @objc dynamic var deadline: Date = Date()
    @objc dynamic var category: String = ""
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var table: UITableView!
    
    public var item: ToDoListItem?
    
    private var realm = try! Realm()
    private var data = [ToDoListItem]() 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(ToDoListItem.self).map({ $0 })
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //automatycznie stworzone przez blad widoki, z bazy
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].item
            
            if data[indexPath.row].category == "Praca" {
                cell.backgroundColor = UIColor.systemGray
            }
            else if data[indexPath.row].category == "Zakupy"{
                cell.backgroundColor = UIColor.systemTeal
            } else {
                cell.backgroundColor = UIColor.systemRed
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "view") as ViewViewController? else {
            return
        }
        
        vc.item = item
        vc.deletionHandler = { [ weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let refreshAlert = UIAlertController(title: "Usuwanie", message: "Cały wpis zostanie usunięty.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            if editingStyle == .delete {

                self.item = self.data[indexPath.row]
                guard let myItem = self.item else {
                    return
                }
                self.realm.beginWrite()
                self.realm.delete(myItem)
                try! self.realm.commitWrite()
                
                
                self.data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } ) )

        refreshAlert.addAction(UIAlertAction(title: "Anuluj", style: .cancel, handler: { (action: UIAlertAction!) in
              //just do nothing
        } ) )
        
        present(refreshAlert, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func didTapAddButton() {
        guard  let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewControlller else {
            return
        }
        vc.completionHandler = {
        [weak self] in
            self?.refresh()
        }
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
        data = realm.objects(ToDoListItem.self).map({ $0 })
        table.reloadData()
    }
    
    public var deletionHandler: (() -> Void)?
    
}

