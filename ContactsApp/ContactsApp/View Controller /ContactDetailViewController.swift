//
//  ContactDetailViewController.swift
//  ContactsApp
//
//  Created by Julia Rodriguez on 7/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    // landing pad
    var contact: Contact?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phonenumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
       guard let name = nameTextField.text, !name.isEmpty,
        let phonenumber = phonenumberTextField.text,
        let email = emailTextField.text else { return }
        
        // check if there is an object in the landing pad already
        if let contact = contact {
            
            // If there is a contact, call the update function
            ContactController.sharedIntance.updateContact(contact: contact, withName: name, phonenumber: phonenumber, email: email)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func updateViews() {
        
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        phonenumberTextField.text = contact.phonenumber
        emailTextField.text = contact.email
    }
    
    func verifyNameisNotEmpty() {
        
    }
    

   

}
