//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Dwayne George on 5/5/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
 
    var allMemes: Meme!
    var btnAdd: UIBarButtonItem? = nil
    var btnBack: UIBarButtonItem? = nil
    var detailImageToShow: UIImage? = nil
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet var colView: UICollectionView!

    override func viewWillAppear(animated: Bool) {
        self.colView.reloadData()  //refresh data in case meme was deleted
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colView.dataSource = self;
        self.colView.delegate = self;
        
        // get saved Memes
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes

        //layout collection view
        let colLayout = UICollectionViewFlowLayout()
        colLayout.itemSize = CGSize(width: 125, height: 125)
        colLayout.minimumInteritemSpacing = 0
        colLayout.minimumLineSpacing = 0
colLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        colView.collectionViewLayout = colLayout
    }
    
    @IBAction func unwindToCollectionView(segue: UIStoryboardSegue) {
       //provided to unwind from Detail View Controller
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "DetailViewCollectionSeque") {
        
            //get reference to controller
            let celIndex = self.colView.indexPathForCell(sender as! UICollectionViewCell)
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = navigationController.viewControllers.first as! DetailViewController
            
            //set variable to pass
            
            if let row = celIndex?.row {
                if let newMeme = self.allMemes.getItem(row)?.memedImage
                {
                    detailViewController.detailImageToShow = newMeme
                    detailViewController.detailImageIndex = celIndex?.row
                    
                } else {
                    println("image doesn't exist")
                }
            } else {
                println("celIndex row returned nil")
            }
        }
        
    }
    
    @IBAction func returnEditMemeView(sender: AnyObject) {
        //dismiss table view and return the editor view
        if (self.presentingViewController != nil)
        {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1  //set the number of sections to one
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count() //return with number of memes stored
    }

    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemePicture 
        
        let thismeme = self.allMemes.getItem(indexPath.row)  //get meme to display
        
        cell.backgroundColor = UIColor.whiteColor() //color of cell
        
        if let newMeme = thismeme {
            cell.customMemeView.image = newMeme.memedImage //image to display
        } else {
            println("Couldn't get meme")
        }
                
        return cell
    }

}