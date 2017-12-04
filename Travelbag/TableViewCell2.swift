//
//  TableViewCell2.swift
//  Travelbag
//
//  Created by ifce on 27/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell, UICollectionViewDataSource {
    var categoryImageArray = [UIImage]()
    var categoryNameArray = [String]()
    
    var delegate: FeedViewControllerDelegate?
    var indexPath : IndexPath?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionInterest", for: indexPath) as! InterestCollectionViewCell
        
        
        
        
        cell.interestImage.image = categoryImageArray[indexPath.row]
        cell.interestName.text = categoryNameArray[indexPath.row]
        return cell
    }
    override func didMoveToWindow() {
        let nibName = UINib(nibName: "InterestCollectionViewCell", bundle: nil)
        collectionInterest.register(nibName, forCellWithReuseIdentifier: "collectionInterest")
        collectionInterest.dataSource = self
        
    }
    

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var collectionInterest: UICollectionView!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var postIcon: UIImageView!
    
    @IBOutlet weak var imagePostHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textPostLabel: UILabel!
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func didTapName(_ sender: UIButton) {
        delegate?.didTapName(at: indexPath!)
    }
    
    @IBAction func didTapLocation(_ sender: UIButton) {
        
        delegate?.didTapLocation(at: indexPath!)
    }
    
    @IBAction func didTapImage(_ sender: Any) {
        delegate?.didTapImage(at: indexPath!)
    }
    @IBAction func didTapProfilePicture(_ sender: Any) {
         delegate?.didTapName(at: indexPath!)
    }
    
}


protocol FeedViewControllerDelegate{
    func didTapName(at: IndexPath)
    func didTapLocation(at: IndexPath)
    func didTapImage(at: IndexPath)
}

