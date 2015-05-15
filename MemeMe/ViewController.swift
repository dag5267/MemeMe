//
//  ViewController.swift
//  MemeMe
//
//  Created by Dwayne George on 5/5/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    //variable for activity view controller
    var activityViewController:UIActivityViewController?
    
    @IBOutlet var thisView: UIView!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var selectToolBar: UIToolbar!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    var btnAlbum: UIBarButtonItem? = nil
    var btnCamera: UIBarButtonItem? = nil
    
    @IBOutlet weak var btnShare: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSStrokeWidthAttributeName : -3.0 ]
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
                
        //reset text in top and bottom text field
        bottomText.text = "BOTTOM"
        topText.text = "TOP"
        
        //disable share button
        btnShare!.enabled = false;
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if appDelegate.memes.count() > 0
        {
            btnCancel.enabled = true  //enable cancel button if there are save memes
        } else
        {
            btnCancel.enabled = false //disable cancel button if there are no saved memes
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create Camera button and set function to call
        btnCamera = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "pickanImageFromCamera")
        
        // create Album button and set function to call
        btnAlbum = UIBarButtonItem(title: "Album", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("pickAlbum"))
        let betweenFixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        let leftMarginFixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: self, action: nil)
        
        //adjust spacing between buttons based on screen width
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        betweenFixedSpace.width = 200 //keep buttons 200 units apart
        
        leftMarginFixedSpace.width = (screenWidth - betweenFixedSpace.width - 125) / 2 //center buttons on toolbar        
        
        //add items to tool bar
        selectToolBar.items = [leftMarginFixedSpace, btnCamera!, betweenFixedSpace, btnAlbum!]
        
        //disable camera if not available
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            btnCamera!.enabled = true;
        } else {
            btnCamera!.enabled = false;
        }
        
        //set text field delegates to us
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        //hide text
        topText.hidden = true;
        bottomText.hidden = true;
        
        //set attributes for text
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        //set text to center horizontal alignment
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        
        // get saved Memes
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.memes.count() > 0
        {
            //seque to Sent Memes if there are any sent memes
            var controller: UITabBarController
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("sbTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil);
        }
        
    }
    
    func pickAlbum() { //pick picture to memme from the album
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {  //process chosen image
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
                
                self.imagePickerView.image = image
                
                topText.hidden = false; //show bottom and top text
                bottomText.hidden = false;
            }
            else {
                println("image not found")
            }
            
            self.dismissViewControllerAnimated(true, completion: nil) //dismiss view
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil) //dismiss view when cancelled tapped
    }
    
    func pickanImageFromCamera() { //handle if user has camera available
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func save() {
        
        //Create the meme
        var newMeme = Meme.sMeme(text_top: topText.text, text_bot: bottomText.text, image: self.imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.addItem(newMeme)
        
    }
    
    func generateMemedImage() -> UIImage
    {
        selectToolBar.hidden = true; //don't capture tool bars in image
        topToolBar.hidden = true;
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        selectToolBar.hidden = false; //restore tool bars
        topToolBar.hidden = false;
        
        return memedImage //return with edited image
    }
    
    @IBAction func startActivityViewController(sender: AnyObject) {
        
        let curImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [curImage], applicationActivities: nil)
        
        //these activities will not cause meme to be saved, all others will e.g. mail, posts .etc
        let activityToSave = [UIActivityTypeSaveToCameraRoll, UIActivityTypeAssignToContact, UIActivityTypePrint,UIActivityTypeCopyToPasteboard]
        
        //set completion handler to show sent Memes
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
            if completed == true {
                if find(activityToSave,activityType) == nil { //save only certain activities, this one is not in the list
                    self.save()  //save memes that have been sent or posted
                }
            }
            
            //show sent memes
            var controller: UITabBarController
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("sbTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil);
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)  //display activity controller
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField === bottomText { //clear text if it hasn't been edited
            if textField.text == "BOTTOM" {
                textField.text = "" //clear text field before editing
            }
        }
        
        if textField === topText { //clear text if it hasn't been edited
            if textField.text == "TOP" {
                textField.text = "" //clear text field before editing
            }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        btnShare!.enabled = true //enable share button after keboard dismisses
        return true;
        
    }
    
}

