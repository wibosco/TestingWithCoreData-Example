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
    
    private var colors = [Color]()
    private var colorsDataManager: ColorsDataManager!
    
    private var flowLayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        let sideLength = (collectionView.frame.size.width - 4.0)/3
        
        flowLayout.itemSize = CGSize(width: sideLength, height: sideLength)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.minimumLineSpacing = 2.0
 
        return flowLayout
    }
    
    // MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorsDataManager = ColorsDataManager()
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - ButtonActions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        colorsDataManager.insertColor()
        loadData()
    }
    
    // MARK: - Load
    
    func loadData() {
        colors = colorsDataManager.colors()
        collectionView.reloadData()
    }
}

extension ColorsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell else {
            fatalError("Unable cell type")
        }
        let color = colors[indexPath.row]

        cell.backgroundColor = UIColor.colorWithHex(hexColor: color.hex!)
        cell.label.text = "\(indexPath.row)"
        
        return cell
    }
}

extension ColorsViewController: UICollectionViewDelegate {
    
}
