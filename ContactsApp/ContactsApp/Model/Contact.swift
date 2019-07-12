//
//  Contact.swift
//  ContactsApp
//
//  Created by Julia Rodriguez on 7/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CloudKit


class Contact {
    
    // variables to use
    var name: String
    var phonenumber: String?
    var email: String?
    
    // cloudKit properties
    let ckRecordID: CKRecord.ID
    
    // memberwise initializer, init ckRecord
    init(name: String, phonenumber: String?, email: String?, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.name = name
        self.phonenumber = phonenumber
        self.email = email
        self.ckRecordID = ckRecordID
    }
    
    // falliable convenience init to create a CKRecord object
    convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[ContactConstants.nameKey] as? String,
        let phonenumber = ckRecord[ContactConstants.phonenumberKey] as? String,
        let email = ckRecord[ContactConstants.emailKey] as? String
            else { return nil }
        
        self.init(name: name, phonenumber: phonenumber, email: email, ckRecordID: ckRecord.recordID)
    }
}

// extend CKRecord, create a Model Object: Contact
extension CKRecord {
    
    convenience init(contact: Contact) {
        
        // create CKRecord Type
        self.init(recordType: ContactConstants.typeKey, recordID: contact.ckRecordID)
        
        // set the values for keys for CKRecord
        self.setValue(contact.name, forKey: ContactConstants.nameKey)
        self.setValue(contact.phonenumber, forKey: ContactConstants.phonenumberKey)
        self.setValue(contact.email, forKey: ContactConstants.emailKey)
    }
    
}

struct ContactConstants {
    static let typeKey = "Contact"
    fileprivate static let nameKey = "name"
    fileprivate static let phonenumberKey = "phonenumber"
    fileprivate static let emailKey = "email"
}

extension Contact: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if name.contains(searchTerm) {
            return true
        }
        return false 
    }
}
