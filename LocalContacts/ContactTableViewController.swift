//
//  ContactTableViewController.swift
//  LocalContacts
//
//  Created by Eashir Arafat on 12/6/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
    
        APIRequestManager.manager.getData("https://api.fieldbook.com/v1/5846eb88a785c00300a9434b/contacts") { (data: Data?) in
            if let validData = data,
                let validContacts = Contact.getContacts(from: validData) {
                self.contacts = validContacts
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        
        APIRequestManager.manager.getData("https://api.fieldbook.com/v1/5846eb88a785c00300a9434b/contacts") { (data: Data?) in
            if let validData = data,
                let validContacts = Contact.getContacts(from: validData) {
                self.contacts = validContacts
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

        refreshControl.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = contacts[indexPath.row]
      
        
        //Make the image round
        cell.imageView?.layer.cornerRadius = 22.5
        cell.imageView?.layer.masksToBounds = true
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.email
        // Configure the cell...
        
        APIRequestManager.manager.getData(contact.image) { (data: Data?) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    
                    cell.imageView?.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        

        return cell
    }
 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dvc = segue.destination as? DetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            dvc.contact = contacts[indexPath.row]
        }
    }
    

}
