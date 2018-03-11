//
//  CollectionViewFetchedResultsControllerDelegateHandler.swift
//  TestingWithCoreData-Example
//
//  Created by William Boles on 11/03/2018.
//  Copyright © 2018 William Boles. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewFetchedResultsControllerDelegateHandler: NSObject {
    
    private let collectionView: UICollectionView
    
    fileprivate var insertionChanges = [IndexPath]()
    fileprivate var updateChanges = [IndexPath]()
    fileprivate var moveChanges = [[IndexPath]]()
    fileprivate var deletionChanges = [IndexPath]()
    
    // MARK: - Init
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
}

extension CollectionViewFetchedResultsControllerDelegateHandler: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //Clear any past changes, regardless of if they have been processed or not
        insertionChanges.removeAll()
        deletionChanges.removeAll()
        moveChanges.removeAll()
        updateChanges.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({
            if insertionChanges.count > 0 {
                collectionView.insertItems(at: insertionChanges)
            }
            
            if deletionChanges.count > 0 {
                collectionView.deleteItems(at: deletionChanges)
            }
            
            if moveChanges.count > 0 {
                for indexPaths in moveChanges {
                    collectionView.moveItem(at: indexPaths[0], to: indexPaths[1])
                }
            }
            
            if updateChanges.count > 0 {
                collectionView.reloadItems(at: updateChanges)
            }
        }, completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            insertionChanges.append(newIndexPath!)
        case .delete:
            deletionChanges.append(indexPath!)
        case .move:
            moveChanges.append([indexPath!, newIndexPath!])
        case .update:
            updateChanges.append(indexPath!)
        }
    }
}
