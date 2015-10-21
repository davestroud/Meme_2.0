//
//  DetailViewController.swift
//  meme_v2
//
//  Created by John David Stroud on 10/19/15.
//  Copyright © 2015 greymatter-home. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var chosenMeme: Meme!
    var indexOfChosenMeme: Int?
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBAction func editButton(send: AnyObject) {
        let memeEditorViewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        //memeEditorViewController.meme = chosenMeme
        presentViewController(memeEditorViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let _ = indexOfChosenMeme{
            appDelegate.memes.removeAtIndex(indexOfChosenMeme!)
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let memedImage = chosenMeme.memedImage {
            detailImageView.image = memedImage
        }
    }
}
