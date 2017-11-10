//
//  ViewController.swift
//  Project12
//
//  Created by Linix on 2017/2/27.
//  Copyright © 2017年 Linix. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        let person = people[indexPath.row]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
   
    func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func save() {
        let saveData = NSKeyedArchiver.archivedData(withRootObject: people)  // 将数组“people”转化为 Data 对象
        let defaults = UserDefaults.standard
        defaults.set(saveData, forKey: "people")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        /* imagePickerController(_, idFinishPickingMediaWithInfo:), which returns when the user selected an image and it's being returned to you. This method needs to do several things:
         1. Extract the image from the dictionary that is passed as a parameter.
         2. Generate a unique filename for it.
         3. Convert it to a JPEG, then write that JPEG to disk.
         4. Dismiss the view controller.
         
        */
 
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unkwon", image: imageName)
        people.append(person)
        collectionView?.reloadData()
        
        dismiss(animated: true)
        
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        /* 
            All apps that are installed have a directory called Documents where you can save private information for the app, and it's also automatically synchronized with iCloud.
            This method finds the directory, the first parameter of FileManager.default.urls asks for the documents directory, and its second parameter adds that we want the path to be relative to the user's home directory.
            This returns an array that nearly always contains only one thing: the user's documents directory. So, we pull out the first element and return it.
        */
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDriectory = paths[0]
        return documentsDriectory
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            
            self.collectionView?.reloadData()
            self.save()
            })
        
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            people = NSKeyedUnarchiver.unarchiveObject(with: savedPeople) as! [Person]
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

