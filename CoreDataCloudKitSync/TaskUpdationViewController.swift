//
//  TaskUpdationViewController.swift
//  CoreDataCloudKitSync
//
//  Created by Isha Dua on 23/03/20.
//  Copyright © 2020 Isha Dua. All rights reserved.
//

import UIKit
import CoreData

class TaskUpdationViewController: UIViewController {
    private var managedObjectContext: NSManagedObjectContext
    private var task: Task
    private weak var titleTextField: UITextField?
    private weak var descriptionTextField: UITextField?
    private let padding: CGFloat = 30
    
    init(context: NSManagedObjectContext, task: Task) {
        self.managedObjectContext = context
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Edit Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTask))
        createViews()
    }
    
    @objc private func saveTask() {
        self.task.taskTitle = titleTextField?.text
        self.task.taskDescription = descriptionTextField?.text
        do {
            try self.managedObjectContext.save()
            navigationController?.popViewController(animated: true)
        } catch {
            let errorAlert = UIAlertController(title: "Trouble Saving",
                                                     message: "Something went wrong while saving. Please try again.",
                                                     preferredStyle: .alert)
                       let okAction = UIAlertAction(title: "OK",
                                                    style: .default,
                                                    handler: {(action: UIAlertAction) -> Void in
                                                       self.managedObjectContext.rollback()
                       })
                       errorAlert.addAction(okAction)
                       self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    private func createViews() {
        let titleLabel = UILabel()
        titleLabel.text = "Task Title"
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tf = UITextField()
        tf.placeholder = "Enter task title"
        tf.text = task.taskTitle
        self.view.addSubview(tf)
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Task Description"
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let df = UITextField()
        df.placeholder = "Enter task description"
        df.text = task.taskDescription
        self.view.addSubview(df)
        df.borderStyle = .roundedRect
        df.translatesAutoresizingMaskIntoConstraints = false
        

        let constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            tf.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            tf.heightAnchor.constraint(equalToConstant: 2*padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: tf.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            df.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            df.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            df.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            df.heightAnchor.constraint(equalToConstant: 2*padding)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.titleTextField = tf
        self.descriptionTextField = df
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
