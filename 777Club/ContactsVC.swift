//
//  ContactsVC.swift
//  777Club
//
//  Created by kavita patel on 9/7/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ContactsVC: UIViewController, UISearchBarDelegate
{
    var contactDict = [NSDictionary]()
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var searchController: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        imageView.image = #imageLiteral(resourceName: "placeholder")
        firstName.text = ""
        lastName.text = ""
        phoneNo.text = ""
    }
    @IBAction func searchBtn(_ sender: AnyObject)
    {
      searchController.resignFirstResponder()
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if error != nil
            {
                AlertViewController.alertView.alertMsg("Firebase Error", msg: (error.debugDescription))
            }
            else
            {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                _ = DataService.ds.REF_PROFILE.observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
                    
                    let postDict = snapshot.value as? [String : AnyObject]
                    if postDict?.count == 0
                    {
                        AlertViewController.alertView.alertMsg("Data Error", msg: "No Record Found")
                    }
                    else
                    {
                        print(snapshot.key)
                        if self.searchController.text == snapshot.key
                        {
                            print("Record match")
                            let dict = snapshot.value as! NSDictionary
                            let base64String = dict.value(forKey: "photoBase64") as? String
                            let decodedData = NSData(base64Encoded: base64String!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                            let decodedImg = UIImage(data: decodedData as! Data)
                            if decodedImg != nil
                            {
                                self.imageView.image = decodedImg
                            }
                            else
                            {
                                self.imageView.image = #imageLiteral(resourceName: "placeholder")
                            }
                            self.firstName.text = dict.value(forKey: "firstname") as? String
                            self.lastName.text = dict.value(forKey: "lastname") as? String
                            self.phoneNo.text = snapshot.key
                        }
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    
                })
                
            }
        }

    }
}
