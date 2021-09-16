//
//  ViewViewController.swift
//  RekrutacjaToDo
//
//  Created by Konrad Tomczuk on 15/09/2021.
//
import RealmSwift
import UIKit

class ViewViewController: UIViewController {
    
    public var item: ToDoListItem?
    public var deletionHandler: (() -> Void)?
    private let realm = try! Realm()
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.deadline)
        categoryLabel.text = item?.category
    }
}
