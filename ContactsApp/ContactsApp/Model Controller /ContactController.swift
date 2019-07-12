//
//  ContactController.swift
//  ContactsApp
//
//  Created by Julia Rodriguez on 7/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    // shared Instance
    static let sharedIntance = ContactController()
    
    // source of truth
    var contacts: [Contact] = []
    
    // dataase declaration
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // CRUD Functions
    
    // Create
    func createContact(name: String, phonenumber: String?, email: String?, completion: @escaping (Contact?) -> Void) {
        // create a new contact
        let newContact = Contact(name: name, phonenumber: phonenumber, email: email)
        
        // create a CKRecord from our Model Object
        let newRecord = CKRecord(contact: newContact)
        
        // save CKRecord to public database
        publicDB.save(newRecord) { (record, error) in
            // handle error
            if let error = error {
                print("There is an error saving the record: \(error.localizedDescription)")
                completion(nil)
                return
            }
            // unwrap successfully saved record
            guard let record = record else { completion(nil) ; return }
            
            // Re-create a contact that was succesfully saved into a CKRecord
            guard let contact = Contact(ckRecord: record) else { completion(nil) ; return }
            
            // append the saved contact to source of truth
            self.contacts.append(contact)
            
            // complete with a contact
            completion(contact)
        }
    }
    
    // save contact / update existing contact
    func updateContact(contact: Contact, withName name: String, phonenumber: String?, email: String?) {
        
        contact.name = name
        contact.phonenumber = phonenumber
        contact.email = email
        
        let recordToSave = CKRecord(contact: contact)
        let database = CloudKitController.shared.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            
            if success {
                print("Updated contact successfully updated!")
            }
        }
        
        
    }
    
    // Read / Fetch all contacts
    func fetchAllContacts(completion: @escaping ([Contact]?) -> Void) {
        
        // query needs a predicate
        let predicate = NSPredicate(value: true)
        
        // create query to fetch contacts
        let query = CKQuery(recordType: ContactConstants.typeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // unwrap records
            guard let records = records else { completion(nil); return }
            
            // iterate through [CKRecord] and intialize non- nil values
            let contacts: [Contact] = records.compactMap( {Contact(ckRecord: $0)} )
            
            // append to source of truth
            self.contacts = contacts
            
            // complete with contacts
            completion(contacts)
        }
    }
    
}
