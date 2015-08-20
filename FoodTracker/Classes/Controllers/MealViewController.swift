//
//  MealViewController.swift
//  FoodTracker
//
//  Created by usr0600370 on 2015/08/18.
//  Copyright (c) 2015年 usr0600370. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
//    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var postField: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    var meal = Meal?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        postField.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func unFocusTextField(sender: AnyObject) {
        postField.resignFirstResponder()
    }
    
    /* @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
    // Hide the keyboard.
    nameTextField.resignFirstResponder()
    // UIImagePickerController is a view controller that lets a user pick media from their photo library.
    let imagePickerController = UIImagePickerController()
    // Only allow photos to be picked, not taken.
    imagePickerController.sourceType = .PhotoLibrary
    // Make sure ViewController is notified when the user picks an image.
    imagePickerController.delegate = self
    presentViewController(imagePickerController, animated: true, completion: nil)
    } */
    
    
    @IBAction func openPhotoLibrary(sender: UIButton) {
        // Hide the keyboard.
        postField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = postField.text ?? ""
            let photo = photoImageView.image
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            meal = Meal(name: name, photo: photo)
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        // Hide the keyboard.
        textView.resignFirstResponder()
        return true
    }

    func textViewDidBeginEditing(textView: UITextView) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func textViewDidChange(textView: UITextView) {
        checkValidMealName()
        navigationItem.title = textView.text
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = postField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
}
