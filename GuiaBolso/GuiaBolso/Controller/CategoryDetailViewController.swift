//
//  CategoryDetailViewController.swift
//  GuiaBolso
//
//  Created by Gustavo Quenca on 05/01/19.
//  Copyright © 2019 Quenca. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    // MARK: -Properties
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    
    var selectedCategoryDetail: CategoryDetail? {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    var selectedCategoryName: String?
    
    private let dataSource = DataSource()
    
    var downloadTask: URLSessionDownloadTask?
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = selectedCategoryName!.capitalizingFirstLetter()
        createSpinnerView()
        spinner.startAnimating()
        
        // Get the category details 
        self.dataSource.getCategoryRequest(for: selectedCategoryName!,completion: { success in
            
            self.spinner.stopAnimating()
            
            if !success {
                print("error")
            }
            
            if case .categoryResults(let list) = self.dataSource.categoryState {
                self.selectedCategoryDetail = list
            }
        })
    }
    
    // MARK: - User Interface
    func updateUI() {
        
        if selectedCategoryDetail?.category != nil {
             valueLabel.text = selectedCategoryDetail?.value
        } else {
            valueLabel.text = "Not Found"
        }
        
        if let iconPath = selectedCategoryDetail?.icon_url {
            let urlImage = "\(iconPath)"
            iconImage.image = UIImage(named: urlImage)
            if let smallURL = URL(string: urlImage) {
                downloadTask = iconImage.loadImage(url: smallURL)
            }
        }
    }
    
    func createSpinnerView() {
        
        spinner.color = .black
        
        spinner.hidesWhenStopped = true
        
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}

