//
//  ColorsViewController.swift
//  TestingWithCoreData-Example
//
//  Created by William Boles on 09/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import UIKit
import CoreData

class ColorsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var colorsDataManager = ColorsDataManager()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let sideLength = (collectionView.frame.size.width - 4.0)/3
        
        flowLayout.itemSize = CGSize(width: sideLength, height: sideLength)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.minimumLineSpacing = 2.0
 
        return flowLayout
    }()
    
    private lazy var fetchedResultsControllerDelegateHandler: CollectionViewFetchedResultsControllerDelegateHandler = {
        return CollectionViewFetchedResultsControllerDelegateHandler(collectionView: self.collectionView)
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<Color> = {
        let fetchRequest = NSFetchRequest<Color>(entityName: Color.className)
        
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self.fetchedResultsControllerDelegateHandler
        
        return fetchedResultsController
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter
    }()
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! self.fetchedResultsController.performFetch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - ButtonActions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        colorsDataManager.createColor()
    }
}

extension ColorsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let color = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            fatalError("no color to show for indexPath: \(indexPath)")
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell else {
            fatalError("Unable cell type")
        }
        
        cell.backgroundColor = UIColor.colorWithHex(hexColor: color.hex!)
        cell.dateLabel.text = dateFormatter.string(from: color.dateCreated!)
        
        return cell
    }
}

extension ColorsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let color = fetchedResultsController.fetchedObjects?[indexPath.row] else {
            return
        }
        
        colorsDataManager.deleteColor(color: color)
    }
}
