//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Dwayne George on 5/5/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, UITableViewDataSource {
    
    var btnAdd: UIBarButtonItem? = nil
    var btnTable: UIBarButtonItem? = nil
    var btnCollection: UIBarButtonItem? = nil
    var detailImageToShow: UIImage? = nil
    var detailImageIndex: Int? = nil
    var tableViewCalled: Bool? = nil  //indicate this view called detail view

    @IBOutlet var tblView: UITableView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    var allMemes: Meme!
    var btnBack: UIBarButtonItem? = nil
    
    override func viewWillAppear(animated: Bool) {
        self.tblView.reloadData() //update display because items might have been removed
    }    
    
    override func viewDidLoad() {
        // get saved Memes
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes
        
        self.tblView.rowHeight = 150;  //set height of row
        
    }
    
    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {
        //indicate unwind point for DetailView to return
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "DetailViewTableSeque") {
            //get reference to detail view controller
            let celIndex = self.tblView.indexPathForCell(sender as! UITableViewCell)
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailViewController = navigationController.viewControllers.first as! DetailViewController
            
            //set up variables to pass to Detail view
            if let thisMeme = self.allMemes.getItem(celIndex!.row) {
                detailViewController.detailImageToShow = thisMeme.memedImage
                detailViewController.detailImageIndex = celIndex?.row
                detailViewController.tableViewCalled = true; //indicate table view is calling
            } else {
                println("Unable to get meme at preparForSeque")
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell

        if let thismeme = self.allMemes.getItem(indexPath.row) {
            // Set the name and image
            cell.textLabel?.text = thismeme.text_top + "..." + thismeme.text_bot
            cell.imageView?.image = thismeme.memedImage
        } else {
            println("Unable to get meme at func tableView")
        }
        
        return cell
    }
    

}