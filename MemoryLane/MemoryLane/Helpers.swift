//
//  Helpers.swift
//  MemoryLane
//
//  Created by Cindy Chen on 12/11/23.
//

import Foundation
import Firebase

class Helpers{
    static func isEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    static func formattedTime(time: Timestamp) -> String {
        let date = time.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm"
        return dateFormatter.string(from: date)
    }
    
    static func validateRegistration(_ username: String, _ password: String, _ passwordConfirmation: String) -> String?{
        if username.isEmpty{
            return "Username can not be blank"
        }
            
        if password.isEmpty{
            return "Password can not be blank"
        }
        
        if passwordConfirmation.isEmpty {
            return "Password Confirmation can not be blank"
        }
        
        if (password != passwordConfirmation) {
            return "Passwords don't match"
        }
        
        if (password.count < 6){
            return "Password must be > 6 characters"
        }

        return nil
    }
}


