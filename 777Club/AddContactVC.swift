//
//  ViewController.swift
//  777Club
//
//  Created by kavita patel on 9/5/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class AddContactVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
             if error != nil
             {
                AlertViewController.alertView.alertMsg("Firebase Error", msg: (error.debugDescription))
            }
            else
             {
                //let isAnonymous = user!.isAnonymous  // true
                //let uid = user!.uid
                
            }
        }
        imagePicker =  UIImagePickerController()
       imagePicker.delegate = self
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
       // NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
       // NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
       // NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func keyboardWillShow(sender: NSNotification)
    {
        self.view.frame.origin.y -= 350
    }
    func keyboardWillHide(sender: NSNotification)
    {
        self.view.frame.origin.y = 0
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
       
        textField.resignFirstResponder()
    }

    @IBAction func takePicture(_ sender: AnyObject)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        else
        {
           AlertViewController.alertView.alertMsg("Camera- Error", msg: "Camera is not supported by your device.")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        imagePicker.dismiss(animated: true, completion: nil)
        img.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgBtn.isHidden = true
        
    }
    @IBAction func addPerson(_ sender: AnyObject)
    {
        if firstName.text == nil || lastName.text == nil || phoneNo.text == nil
        {
           AlertViewController.alertView.alertMsg("Information Error", msg: "Person information can't be empty")
        }
        else
        {
            let firstNm = firstName.text
            let lastNm = lastName.text
            let phone = phoneNo.text
            let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: phoneNo.text)
            if result
            {
                imgBtn.isHidden = false
                var data: Data = Data()
                
                if let image = img.image
                {
                    data = UIImageJPEGRepresentation(image,0.1)!
                }
                //convert image
                let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)

                //
                let user: NSDictionary = ["firstname":firstNm!,"lastname":lastNm!, "photoBase64":base64String]
                
                
                //add firebase child node
                let profile = DataService.ds.REF_PROFILE.child(phone!)
                
                // Write data to Firebase
                profile.setValue(user)
                
                img.image = #imageLiteral(resourceName: "placeholder")
                firstName.text = ""
                lastName.text = ""
                phoneNo.text = ""
                
            }
            else
            {
                AlertViewController.alertView.alertMsg("Phone number-Err", msg: "Phone number is not valid")
            }
        }
    }
    

}

