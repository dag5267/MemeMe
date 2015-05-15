//
//  DataTypes.swift
//  MemeMe
//
//  Created by Dwayne George on 5/5/15.
//  Copyright (c) 2015 Dwayne George. All rights reserved.
//

import UIKit

//class to wrap array so sharing is by reference

class Meme
{
    struct sMeme {
    var text_top: String
    var text_bot: String
    var image: UIImage //original image
    var memedImage: UIImage //image with annotations
    }

    var memes = [sMeme]() //create array for this class
    
    func addItem (newItem: sMeme) { //function to add a new Meme
        memes.append(newItem)
    }
    
    func removeItem(idx: Int) { //function to delete a Meme
       memes.removeAtIndex(idx)
    }
    
    func count() ->Int { //function to return a count of Memes in array
        return memes.count
    }
    
    func getItem (idx: Int) ->sMeme? { //return a Meme
        
        if(count() > idx) { //ensure array is not over indexed
          return memes[idx]
        }
        
        return nil //idx doesn't exist
    }
    
    func isValidImage(Item: UIImage, idx: Int) ->Bool   {
        //function to validate Meme is still valid because it could have been deleted.
    
        if(count() > idx) //make certain array is not over idexed
        {
            return (Item === memes[idx].memedImage)  //return true if images are the same
        }
        
        return false
        
        }

}
