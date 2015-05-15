//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Dwayne George on 5/9/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet weak var detailMemeImage: UIImageView!
    
    var tableViewCalled: Bool? = nil //true if called from table view controller
    
    var detailImageIndex: Int? = nil //index to meme to allow deletion from view controller
    var detailImageToShow: UIImage? = nil //the image to display from view controller
    var appDelegate: AppDelegate? = nil //get appDelegate for a reference to Meme class
    
    override func viewWillAppear(animated: Bool) {
        // get saved Memes
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as? AppDelegate
        var validImage = appDelegate!.memes.isValidImage(detailImageToShow!, idx: detailImageIndex!)
        
        if ( validImage != true) {
            //meme image no longer valid...return to calling view controller
            returnToViewController() //go back to previous view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailMemeImage.image = detailImageToShow //set image to display
        detailMemeImage.contentMode = UIViewContentMode.ScaleAspectFit

        // get saved Memes
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as? AppDelegate
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        
        //delete meme and return to calling view
        if detailImageIndex != nil
        {
            appDelegate!.memes.removeItem(detailImageIndex!)
            
        } else {
            println("Can't delete. Meme index nil")
        }
        
        returnToViewController() //go back to previous view
    }
  
    func returnToViewController()
    {
        if(tableViewCalled == true) { //return back to calling view
            performSegueWithIdentifier("id_unWindToTableView", sender: self)
        } else {
            performSegueWithIdentifier("id_unWindToCollectionView", sender: self)
            
        }
    }

}