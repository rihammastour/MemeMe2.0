//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Riham Mastour on 06/10/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    let textFDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //if the divice does not have a camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //textFields
        editingTextField(textFieldToBeEdited: topTextField, direction: "TOP")
        editingTextField(textFieldToBeEdited: bottomTextField, direction: "BOTTOM")
        
        //must choose image to be enabled
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
   
    // MARK: PICK AN IMAGE
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    //to pick an image from UIImagePickerController()
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               imagePickerView.image = image
               imagePickerControllerDidCancel(picker: picker)
             }

           shareButton.isEnabled = true
           cancelButton.isEnabled = true
       }
       
      //to dismiss UIImagePickerController()
      private func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
          picker.dismiss(animated: true, completion: nil)
      }

    
    
    // MARK: ALBUM
    
    //generate UIImagePickerController() from Album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
          pickAnImage(sourceType: .photoLibrary)
    }
    
    
    //MARK: CAMERA
    
    //generate UIImagePickerController() from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(sourceType: .camera)
    }
  
    
    //MARK: TEXT FIELDS
    
    //Processing Text Field
    func editingTextField(textFieldToBeEdited: UITextField, direction: String) {
        
        //Delegate
        textFieldToBeEdited.delegate = textFDelegate
        
        //Top or Bottom
        (direction == "TOP") ? (textFieldToBeEdited.text = "TOP") : (textFieldToBeEdited.text = "BOTTOM")
        
        //Text Properties
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -2
        ]
        textFieldToBeEdited.defaultTextAttributes = memeTextAttributes
        textFieldToBeEdited.textAlignment = .center

        
    }
    
    
    //MARK: KEYBOARD
    
    func subscribeToKeyboardNotifications() {
        //keyboardWillShow
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //keyboardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        //keyboardWillShow
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //keyboardWillHide
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        //change the hieght when bottomTextField is editing
      if bottomTextField.isEditing, view.frame.origin.y == 0{
           view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        //change to original hieght
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    //MARK: SAVE
    
    func save() {
            // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
    }
    
    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false

        return memedImage
    }
    
    
    //MARK: SHARE
    
    @IBAction func shareMemedImage(_ sender: Any) {
        
            shareButton.isEnabled = true
           let memedImage = generateMemedImage()
           let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
           
            activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
                 
            }
        }
           present(activityController, animated: true, completion: nil)
           
    }
    
    
    //MARK: CANCEL
    
    @IBAction func cancelMemedImage(_ sender: Any) {
        shareButton.isEnabled = false
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        cancelButton.isEnabled = false
        
    }
    
    
    
   
}

