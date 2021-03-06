//
//  ProjectManager - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    
    private let todoViewController = ProjectListViewController(step: .todo)
    private let doingViewController = ProjectListViewController(step: .doing)
    private let doneViewController = ProjectListViewController(step: .done)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureToolBar()
        registerDelegate()
        configureListViewLayout()
    }
    
    private func configureNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodo))
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Project Manager"
        navigationController?.navigationBar.barTintColor = .systemGray6
    }
    
    @objc private func addTodo() {
        showTaskViewController(for: .add)
    }
    
    private func showTaskViewController(for task: Task, todo: Todo? = nil) {
        let taskViewController = TaskViewController(task: task, todo: todo)
        taskViewController.delegate = todoViewController
        taskViewController.popoverPresentationController?.sourceView = view
        taskViewController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.midX,
                                                                              y: view.frame.midY,
                                                                              width: 0,
                                                                              height: 0)
        taskViewController.popoverPresentationController?.permittedArrowDirections = []
        let popoverController = UINavigationController(rootViewController: taskViewController)
        
        present(popoverController, animated: true, completion: nil)
    }
    
    private func configureToolBar() {
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = .systemGray5
    }
    
    private func registerDelegate() {
        todoViewController.delegate = self
        doingViewController.delegate = self
        doneViewController.delegate = self
    }
    
    private func configureListViewLayout() {
        let todoTableView = todoViewController.tableView
        let doingTableView = doingViewController.tableView
        let doneTableView = doneViewController.tableView
        let stackView = UIStackView(arrangedSubviews: [todoTableView, doingTableView, doneTableView])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemGray4
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TodoEditDelegate

extension MainViewController: TodoEditDelegate {
    func showTaskViewController(with todo: Todo) {
        showTaskViewController(for: .edit, todo: todo)
    }
    
    func moveToTodo(with todo: Todo) {
        todoViewController.append(todo)
    }
    
    func moveToDoing(with todo: Todo) {
        doingViewController.append(todo)
    }
    
    func moveToDone(with todo: Todo) {
        doneViewController.append(todo)
    }
}
