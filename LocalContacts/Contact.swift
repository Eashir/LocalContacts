//
//  Contact.swift
//  LocalContacts
//
//  Created by Eashir Arafat on 12/6/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import Foundation
import UIKit

enum contactParseError: Error {
    case response, name, email, image
}

class Contact {
    let name: String
    let email: String
    let image: String
    var uiColor: CGColor
    
    init(name: String, email: String, image: String, uiColor: CGColor) {
        self.name = name
        self.email = email
        self.image = image
        self.uiColor = uiColor
    }
    
    static func getContacts(from data: Data?) -> [Contact]? {
        var contacts: [Contact]? = []
        
        do {
            
            // 6. serialize and make object
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
            
            guard let response = jsonData as? [[String: Any]]
                else { throw contactParseError.response }
            
            for contact in response {
                
                guard let name = contact["name"] as? String
                    else { throw contactParseError.name }
                guard let email = contact["email"] as? String
                    else { throw contactParseError.email }
                guard let image = contact["image"] as? String
                    else { throw contactParseError.image }
                
                let validContact = Contact(name: name, email: email, image: image, uiColor: UIColor.black.cgColor)
                contacts?.append(validContact)
            }
            
            return contacts
            
        }
        catch {
            print("Problem casting json: \(error)")
        }
        
        
        return nil
    }
  
    
}




