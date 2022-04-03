//
//  ViewController.swift
//  ShoppingList
//
//  Created by Soner Karaevli on 3.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addBtn))
    }
    
    @objc func addBtn(){
        performSegue(withIdentifier: "toAddItemVC", sender: nil)
    }

}

