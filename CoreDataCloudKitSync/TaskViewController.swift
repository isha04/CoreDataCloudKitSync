//
//  ViewController.swift
//  CoreDataCloudKitSync
//
//  Created by Isha Dua on 21/03/20.
//  Copyright © 2020 Isha Dua. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private var managedObjectContext: NSManagedObjectContext
    private weak var tableView: UITableView!
    private var fetchedResultsController: NSFetchedResultsController<Task>?
    private var diffableDataSource: TaskTableViewDiffableDataSource?
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Tasks"
        createTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTask))
        setupTableView()
        loadSavedData()
    }
        
    // MARK: Add tableView to subView
    private func createTableView() {
        let tb = UITableView()
        self.view.addSubview(tb)
        tb.backgroundColor = .white
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tb.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            tb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tb.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tb.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tb.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
        NSLayoutConstraint.activate(constraints)
        self.tableView = tb
    }
    
    private func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Task.createFetchRequest()
            let sort = NSSortDescriptor(key: "taskTitle", ascending: true)
            request.sortDescriptors = [sort]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
        }

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Fetch failed")
        }
    }

    
    @objc private func addTask() {
        let alertController = UIAlertController(title: "Add a new task", message: "", preferredStyle: .alert)
       
        alertController.addTextField { (taskTitleTextField) in
            taskTitleTextField.placeholder = "Enter Task Title"
        }
        
        alertController.addTextField { (taskDeccriptionTextField) in
            taskDeccriptionTextField.placeholder = "Enter Task Description"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let titleTextField = alertController.textFields![0] as UITextField
            let descriptionTextField = alertController.textFields![1] as UITextField
            self.saveTask(titleTextField.text ?? "Title", descriptionTextField.text ?? "Default Description")
            
        })
                
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func saveTask(_ title: String, _ description: String) {
        var taskToSave = (NSEntityDescription.insertNewObject(forEntityName: "Task",
        into: self.managedObjectContext) as! Task)
        taskToSave.taskTitle = title
        taskToSave.taskDescription = description
        do {
            try self.managedObjectContext.save()
        } catch {
            let errorAlert = UIAlertController(title: "Trouble Saving",
                                          message: "Something went wrong while saving. Please try again.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: {(action: UIAlertAction) -> Void in
                                            self.managedObjectContext.rollback()
                                            taskToSave = NSEntityDescription.insertNewObject(forEntityName: "Task", into: self.managedObjectContext) as! Task
                                            
            })
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskViewController {
    // MARK: NSFetchedResultsController Delegate methods
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        self.diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension TaskViewController {
    
    // MARK:  Create NSDiffableDataSource
    private func setupTableView() {
        diffableDataSource = TaskTableViewDiffableDataSource(tableView: tableView) { (tv, indexPath, id) -> UITableViewCell? in
            var cell = tv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.accessoryType = .disclosureIndicator
            let taskObject = self.fetchedResultsController?.object(at: indexPath)
            cell.textLabel?.text = taskObject?.taskTitle
            cell.detailTextLabel?.text = taskObject?.taskDescription
            return cell
        }
        tableView.delegate = self
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = self.fetchedResultsController?.object(at: indexPath) {
            let taskUpdationVC = TaskUpdationViewController(context: managedObjectContext, task: task)
            tableView.deselectRow(at: indexPath, animated: false)
            navigationController?.pushViewController(taskUpdationVC, animated: true)
        }
    }
}

