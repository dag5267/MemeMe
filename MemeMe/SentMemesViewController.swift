//
//  SentMemesViewController.swift
//  MemeMe
//
//  Created by Dwayne George on 5/5/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController, UITableViewDataSource {
    var btnAdd: UIBarButtonItem? = nil
    var btnTable: UIBarButtonItem? = nil
    var btnCollection: UIBarButtonItem? = nil
    
    @IBOutlet weak var topToolBar: UIToolbar!
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    var allMemes: [Meme]? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create add button and set function to call
        btnAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "returnEditMemeView")
        
        //create fixed space object to right justify add button
        let createSpaceBottom = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil);
        createSpaceBottom.width = 280
        
        //append and right align add button to top toolbar
        topToolBar.items = [createSpaceBottom,btnAdd!]
        
        // get saved Memes
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes
        
    }
    
    func returnEditMemeView()
    {
        //dismiss table view and return the editor view
        if (self.presentingViewController != nil)
        {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let thismeme = self.allMemes![indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = thismeme.text_top + "..." + thismeme.text_bot
        
        cell.imageView?.image = thismeme.image
        
        // If the cell has a detail label, we will put the evil scheme in.
        //        if let detailTextLabel = cell.detailTextLabel {
        //            detailTextLabel.text = "Scheme: \(villain.evilScheme)"
        //        }
        
        return cell
    }
    
    
    func ReturnToEditor()
    {
        
    }
}