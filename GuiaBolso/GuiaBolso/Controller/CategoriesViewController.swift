//
//  CategoriesViewController.swift
//  GuiaBolso
//
//  Created by Gustavo Quenca on 03/01/19.
//  Copyright © 2019 Quenca. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: -Properties
    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource = DataSource()
    
    struct TableViewCellIdentifiers {
        static let categoryCell = "CategoryTableViewCell"
        static let nothingFoundCell = "NothingFoundTableViewCell"
        static let loadingCell = "LoadingTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        dataSource.getRequest(completion: { success in
            self.tableView.reloadData()
        })
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.categoryCell, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.categoryCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
    }
}

// MARK: -Table View Delegates

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataSource.state {
        case .loading:
            return 1
        case .noResults:
            return 1
        case .results(let list):
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch dataSource.state {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
            return cell
            
        case .noResults:
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            
        case .results(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.categoryCell, for: indexPath) as! CategoryTableViewCell
            
            let categories = list[indexPath.row]
            cell.configure(for: categories)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CategoryDetail", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryDetail" {
            
            let detailViewController = segue.destination as! CategoryDetailViewController
            let indexPath = sender as! IndexPath
            if case .results(let list) = dataSource.state {
                detailViewController.selectedCategoryName = list[indexPath.row]
            }
        }
    }
}

