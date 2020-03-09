//
//  ViewController.swift
//  MyFinal
//
//  Created by Brittany Mason on 2/17/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK: Set up Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Set up Variables
    var cityName: [NSManagedObject] = []
    var selectedIndex = 0
    var specificCity = ""
    var peeps : [Person]?
    var dataController: CoreDataStack!

//        let context: NSManagedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        fetchPerson()
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPerson()
//        let perso = loadAllPersons(name: "Person")
//        print(perso as Any)
        let managedContext = appDelegate.persistentContainer.viewContext

        //       let lists = fetchRecordsForEntity("Person", inManagedObjectContext: managedContext)
//       Person = lists
//        print(lists)
        
        // refactored this into the FetchPerson func
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        //            return
        //        }
        //        //Person here are the names of the city, only attribute is 'name'
        //        let managedContext = appDelegate.persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        //
        //        do {
        //            cityName = try managedContext.fetch(fetchRequest)
        //        } catch let error as NSError {
        //            print("Could not fetch. \(error), \(error.userInfo)")
        //        }
    }
    
   

//    func fetchAllPersons(_ predicate: NSPredicate? = nil, entityName: String, sorting: NSSortDescriptor? = nil) throws -> [Person]? {
//        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        let managedContext = appDelegate.persistentContainer.viewContext
//        fr.predicate = predicate
//        if let sorting = sorting {
//            fr.sortDescriptors = [sorting]
//
//        }
//        guard let per = try managedContext.fetch(fr) as? [Person] else {
//            return nil
//        }
//        return per
//    }
//
//    private func loadAllPersons(name: String) -> [Person]? {
//           let predicate = NSPredicate(format: "name == %@" , name )
//           var per: [Person]?
//           do {
//               try per = fetchAllPersons(predicate, entityName: "Person")
//           } catch {
//               print("\(#function) error:\(error)")
//               showInfo(withTitle: "Error", withMessage: "Error while fetching location: \(error)")
//           }
//           return per
//       }
//
    func fetchPersonhelp(_ predicate: NSPredicate, entityName: String, sorting: NSSortDescriptor? = nil) throws -> Person? {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
           fr.predicate = predicate
           if let sorting = sorting {
               fr.sortDescriptors = [sorting]
           }
// orgiginal
//        guard let per = (try dataController.context.fetch(fr) as! [Person]).first else {
        // end of org
            guard let per = (try managedContext.fetch(fr) as! [Person]).first else {
               return nil
           }
           return per
       }
    
    private func loadPerson(name: String) -> Person? {
           let predicate = NSPredicate(format: "name == %@", name)
           var per: Person?
           do {
               try per = fetchPersonhelp(predicate, entityName: "Person")
           } catch {
               print("\(#function) error:\(error)")
               showInfo(withTitle: "Error", withMessage: "Error while fetching location: \(error)")
           }
           return per
       }
    
    //MARK: Origionial Fetch that populates list view
    func fetchPerson() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //Person here are the names of the city, only attribute is 'name'
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")

        do {
            cityName = try managedContext.fetch(fetchRequest)
            peeps = cityName as? [Person]

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
  

    
    
    
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        tableView.reloadData()
    }
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        print (person)
        
        do {
            try managedContext.save()
            cityName.append(person)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! CityViewController
            let sender = sender as! Person
            detailVC.nameOfSelectedCity = specificCity
            detailVC.cityViewPerson = peeps
            detailVC.personvar = sender
        }
    }
    
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = cityName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = cityName[indexPath.row]
        let city = selection.value(forKeyPath: "name") as? String
        specificCity = city!
        let aCity = Person.self
        print("Selected Index", selectedIndex)
        print("This is indexPath", indexPath)
        print(selection)
        print("Just City name", city as Any)
        if let per = loadPerson(name:String(city!)) {
        if isEditing {

            save()
            return
        }
            print("This is the single city loc", per)
        performSegue(withIdentifier: "showDetail", sender: per)

        
        //MARK: testing seg
        //        performSegue(withIdentifier: "showDetail", sender: aCity)
        //----------
        //MARK: Original seg
//                performSegue(withIdentifier: "showDetail", sender: self)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {
            
        }
    }
    
    
    
}

}
