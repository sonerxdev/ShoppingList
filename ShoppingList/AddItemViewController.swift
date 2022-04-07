//
//  AddItemViewController.swift
//  ShoppingList
//
//  Created by Soner Karaevli on 3.04.2022.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

 
    @IBOutlet weak var imageNameTxt: UITextField!
    
    @IBOutlet weak var imagePriceTxt: UITextField!
    @IBOutlet weak var imageSizeTxt: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedItemName: String = ""
    var selectedItemUUID : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedItemName != "" {
            
            if let uuidString = selectedItemUUID?.uuidString{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        for result in results as! [NSManagedObject]{
                            
                            if let name = result.value(forKey: "name") as? String {
                                imageNameTxt.text = name
                            }
                            if let price = result.value(forKey: "price") as? Int {
                                imagePriceTxt.text = String(price)
                            }
                            
                            if let size = result.value(forKey: "size") as? String {
                                imageSizeTxt.text = size
                            }
                            
                            if let imageData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: imageData)
                                imageView.image = image
                                
                            }
                        }
                    }
                }
                catch{
                    debugPrint("problem")
                }
                
            }
            
        }
        else {
            imageNameTxt.text = ""
            imagePriceTxt.text = ""
            imageSizeTxt.text = ""
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeKeyboard (){
        view.endEditing(true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        shopping.setValue(imageNameTxt.text!, forKey: "name")
        shopping.setValue(imageSizeTxt.text!, forKey: "size")
        
        if let price = Int(imagePriceTxt.text!){
            shopping.setValue(price, forKey: "price")
        }
        
        shopping.setValue(UUID(), forKey: "id")
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        
        shopping.setValue(data, forKey: "image")
        
        do {
            try context.save()
            debugPrint("saved")
        }
        catch{
            debugPrint("problem") 
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataAdded"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
}
