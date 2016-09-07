//
//  DataService.swift
//  777Club
//
//  Created by kavita patel on 9/7/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

let URL_BASE: String = "https://club-2ac74.firebaseio.com/"

class DataService
{
    static var ds = DataService()
    
    private var _REF_BASE = FIRDatabase.database().reference(fromURL: URL_BASE)
    private var _REF_PROFILES = FIRDatabase.database().reference(fromURL: "\(URL_BASE)/Profiles")
    var REF_BASE: FIRDatabaseReference
    {
        return _REF_BASE
    }
    var REF_PROFILE: FIRDatabaseReference
    {
        return _REF_PROFILES
    }
    
    
}
