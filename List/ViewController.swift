    //
    //  ViewController.swift
    //  List
    //
    //  Created by Alex Jeffers on 10/16/19.
    //  Copyright © 2019 asapinc. All rights reserved.
    //

    import UIKit
    import CoreData

    class ViewController: UIViewController {
        
        
        @IBOutlet weak var tableView: UITableView!
        
        var teamss: [NSManagedObject] = []
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            //1
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            //2
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "Teams")
            
            //3
            do {
                teamss = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
           
            title = "Football Teams"
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            
            
        }
        
     

        //Add names with alert controller
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            let alertController = UIAlertController(title: "Add a team.", message: "Please enter a team name", preferredStyle: .alert)
         
            let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
                guard let textField = alertController.textFields?.first,
                    let nameTosave = textField.text else {
                        return
                }
                
                self.save(name: nameTosave)
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title:"Cancel", style: .cancel)
            
            alertController.addTextField()
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        
       }
        
        // Function to save to core data
        func save(name: String) {
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            // 1
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            // 2
            let entity =
                NSEntityDescription.entity(forEntityName: "Teams",
                                           in: managedContext)!
            
            let team = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            // 3
            team.setValue(name, forKeyPath: "teamName")
            
            // 4
            do {
                try managedContext.save()
                teamss.append(team)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }

    }
    
    // MARK: - UITableViewDataSource
    extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return teamss.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let teams = teamss[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            // Grabbing name from data model with "teamName"
            cell.textLabel?.text = teams.value(forKeyPath: "teamName") as? String
            return cell
        }
        
        
        
        
        
    }

