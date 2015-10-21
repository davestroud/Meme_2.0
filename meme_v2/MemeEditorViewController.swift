//
//  MemeEditorViewController.swift
//  meme_v2
//
//  Created by greymatter-home on 10/13/15.
//  Copyright © 2015 greymatter-home. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var imagePickerView: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memedImage : UIImage!
    var chosenMeme: Meme!
    
    // creates the meme.  Initializes the Meme model object.  Created and works with struct file.
    func save() -> Meme {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        return meme
    }
    
    //  method to generate the meme while hiding and unhiding the tool bars
    // combines the original image with overlayed text
    func generateMemedImage() -> UIImage
    {
        // hides toolbar and navbar
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        // renders view to image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //  shows toolbar and navbar
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
        return memedImage
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set font style and color with textAttributes
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: NSNumber(float: -3.0),
        ]
        
        // Setting the defaultTextAttributes
        setupTextField(topTextField, text: " TOP ", delegate: self, attributes:
            memeTextAttributes, alignment: NSTextAlignment.Center)
        setupTextField(bottomTextField, text: "BOTTOM ", delegate: self, attributes:
            memeTextAttributes, alignment: NSTextAlignment.Center)
    }
    
    func setupTextField (textField: UITextField, text: String, delegate: UITextFieldDelegate,
        attributes: [String : NSObject], alignment: NSTextAlignment) {
            textField.text = text
            textField.delegate = delegate
            textField.defaultTextAttributes = attributes
            textField.textAlignment = alignment
    }
    
    var memes: [Meme]!
    // Sign up to be notified when the keyboard appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    // when the keyboardWillShow notification is received, shift the view frame up
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // When the keyboardWillHide notification is received, shift the view frame down
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // declare function to sign up to be notified when the keyboard appears
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:",name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // declare function to sign up to be notified when the keyboard disappears
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Launch the image picker and set the UIImagePickerControllerDelegate:
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // Specifying sourceType
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // Specifying sourceType
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareAnImage(sender: AnyObject) {
        let newMeme = save()
        let memedImage = newMeme.memedImage
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(nextController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAnImage(sender: UIBarButtonItem) {
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        imagePickerView.image = nil
        shareButton.enabled = false
        cancelButton.enabled = false
    }
    
    // Retrieve the image from the image picker.  Receive the image from the delegate pattern
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Makes the keyboard come back down when user presses return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        // Finish implementing the method
        return true
    }
    
}
