//
//  DetailViewController.swift
//  LocalContacts
//
//  Created by Eashir Arafat on 12/6/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var contact: Contact?
    var pixelColorDVC = UIColor()
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var contactImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = contact?.name
        // Do any additional setup after loading the view.
        guard let endPoint = contact?.image else { return }
        
        APIRequestManager.manager.getData(endPoint) { (data: Data?) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    
                    self.contactImage.image = validImage
                    
                }
            }
        }
        
        contactImage.layer.cornerRadius = (contactImage.frame.size.width) / 2
        contactImage.layer.masksToBounds = true
        contactImage.layer.borderColor = contact?.uiColor
        
       
    }
    
    @IBAction func clickDoneToPOST(_ sender: UIBarButtonItem) {
        
        guard let firstName = firstNameTextField.text else {
            print("No first name given")
            return
        }
        guard let lastName = lastNameTextField.text else {
            print( "Last name not given")
            return
        }
        guard let email = emailTextField.text else {
            print("No email given")
            return
        }
        let name = firstName + " " + lastName
        APIRequestManager.manager.postu(name: name, email: email)
    }
    
    
    

    
    
    
    
}
