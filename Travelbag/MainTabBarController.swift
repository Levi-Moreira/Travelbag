//
//  MainTabBarController.swift
//  Travelbag
//
//  Created by ifce on 14/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
class MainTabBarController: RAMAnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        if let items = self.tabBar.items {
//            
//            //Get the height of the tab bar
//            
//            let height = self.tabBar.bounds.height
//            
//            //Calculate the size of the items
//            
//            let numItems = CGFloat(items.count)
//            let itemSize = CGSize(
//                width: tabBar.frame.width / numItems,
//                height: tabBar.frame.height)
//            
//            for (index, _) in items.enumerated() {
//                
//                //We don't want a separator on the left of the first item.
//                
//                if index > 0 {
//                    
//                    //Xposition of the item
//                    
//                    let xPosition = itemSize.width * CGFloat(index)
//                    
//                    /* Create UI view at the Xposition,
//                     with a width of 0.5 and height equal
//                     to the tab bar height, and give the
//                     view a background color
//                     */
//                    let separator = UIView(frame: CGRect(
//                        x: xPosition, y: 0, width: 0.5, height: height))
//                    separator.backgroundColor = UIColor.gray
//                    tabBar.insertSubview(separator, at: 1)
//                }
//            }
//        }
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
