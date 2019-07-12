//
//  ContactListTableViewController.swift
//  ContactsApp
//
//  Created by Julia Rodriguez on 7/12/19.
//  Copyright © 2019 Julia Rodriguez. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    @IBOutlet weak var contactSearchBar: UISearchBar!
    
    var contactResultsArray: [SearchableRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContact()
        loadViewIfNeeded()
        contactSearchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // contactResultsArray = ContactController.sharedIntance.contacts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactController.sharedIntance.contacts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        // grab a single contact from the array of contacts
        let contact = ContactController.sharedIntance.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        
        if let phonenumber = contact.phonenumber {
        cell.detailTextLabel?.text = "\(phonenumber)"
            // do i need to add return, inside scope 
        }

        return cell
    }
    
    @IBAction func addContactButtonTapped(_ sender: Any) {
        presentContactAlert(title: "New Contact", message: "Add contact info")
    }
    
    func fetchContact() {
        ContactController.sharedIntance.fetchAllContacts { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    func presentContactAlert(title: String, message: String) {
        
        // initiate and instance of UIAlertController
        // title - header labe, message - memo on alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // contact textfield [0]
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Add Contact Name..."
            textfield.autocorrectionType = .yes
        }
        
        // phone number textfield[1]
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Add phone number..."
            textfield.keyboardType = .phonePad
        }
        
        // email textfield[2]
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Add email..."
            textfield.keyboardType = .emailAddress
        }
        
        // add a save contact action
        
        let saveContactAction = UIAlertAction(title: "Save Contact", style: .default) { (_) in
            guard let nameText = alertController.textFields?[0].text,
            let phonenumber = alertController.textFields?[1].text,
            let email = alertController.textFields?[2].text,
            !nameText.isEmpty
                else { return }
            
            // create new posts from singleton function
            ContactController.sharedIntance.createContact(name: nameText, phonenumber: phonenumber, email: email, completion: { (_) in
                // update in main thread / UI
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        
        // Add cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // add all action to alertcontroller
        alertController.addAction(saveContactAction)
        alertController.addAction(cancelAction)
        
        // all complete, present alertController
        self.present(alertController, animated: true)
        
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // identifier
        if segue.identifier == "toDetailVC" {
            // destination
            let destinationViewController = segue.destination as? ContactDetailViewController
            // object to send
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = ContactController.sharedIntance.contacts[indexPath.row]
            // object to set
            destinationViewController?.contact = contact
        }
    }
}

extension ContactListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // filter through the singleton using contact objects(matches: )
        contactResultsArray = ContactController.sharedIntance.contacts.filter {
            $0.matches(searchTerm: searchText)
        }
        tableView.reloadData()
    }
}
