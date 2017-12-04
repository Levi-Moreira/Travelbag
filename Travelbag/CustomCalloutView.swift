//
//  CustomCalloutView.swift
//  Travelbag
//
//  Created by IFCE on 13/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView, UICollectionViewDataSource {
	
	@IBOutlet weak var viewHeight: NSLayoutConstraint!
	@IBOutlet weak var imagePost: UIImageView!
	@IBOutlet weak var nameUser: UILabel!
	@IBOutlet weak var imageCollectionView: UICollectionView!
	@IBOutlet weak var location: UILabel!
	
	var categoryImageArray = [UIImage]()
	var uid : String?
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categoryImageArray.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionView", for: indexPath) as! ImageCollectionView
		cell.categoryImage.image = categoryImageArray[indexPath.row]
		return cell
	}
	
	override func didMoveToWindow() {
		let nibName = UINib(nibName: "ImageCollectionView", bundle: nil)
		imageCollectionView.register(nibName, forCellWithReuseIdentifier: "imageCollectionView")
		imageCollectionView.dataSource = self
	}
	
	
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
