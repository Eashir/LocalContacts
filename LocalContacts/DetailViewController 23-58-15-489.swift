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
        postu()
    }
    
    func postu() {
        
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
        
        var request: URLRequest = URLRequest(url: URL(string: "https://api.fieldbook.com/v1/5846eb88a785c00300a9434b/contacts")!)
        
        request.httpMethod = "POST"
        
        let headers = [
            "content-type": "application/json",
            "authorization": "Basic a2V5LTc6UlBtMERkQTExWS1OWjZoQXduTGI=",
            "cache-control": "no-cache",
            "postman-token": "395019a8-b41c-69ad-bd9d-c0eb14dc3e33"
        ]
        
        let parameters = [
            "name": "\(name)",
            "email": "\(email)",
            "role": "Fighter",
            "company": "Riot Games",
            
            "image": "http://pre08.deviantart.net/cb66/th/pre/f/2016/282/0/a/yasuo_by_saya94-dakdrqi.png"
        ]
        request.allHTTPHeaderFields = headers
        
        do {
            let postData: Data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData
        }
        catch { 
            print("Error converting to data")
        }
        
        let session: URLSession = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        }.resume()
    }
    
    
    
    
}
