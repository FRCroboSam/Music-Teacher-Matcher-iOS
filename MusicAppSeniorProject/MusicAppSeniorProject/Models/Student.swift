//
//  Student.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/23/23.
//

import Foundation
import SwiftUI

struct Student: Identifiable{
    let id = UUID()
    var name: String
    var uiImage: UIImage?
    var firstName: String = ""
    var lastName: String = ""
    var age: Double = 12
    var price: Double = 0
    var email: String = ""
    var selectedInstrument: String = ""
    var password: String = ""
    var uid: String = "NO UID"
    //dictionary, use this to print names
    var loginInfo:KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("", ""))
    var personalInfo:KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("", ""))
    var musicalBackground:KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("", ""))

    
    mutating func populateInfo(personalInfo:KeyValuePairs<String, String>, loginInfo:KeyValuePairs<String, String>, musicalBackground:KeyValuePairs<String, String>){
        self.personalInfo = personalInfo
        self.loginInfo = loginInfo
        self.musicalBackground = musicalBackground
    }

    mutating func setUID(uid: String){
        self.uid = uid 
    }
    //creates a generic student object
    static func createGenericStudent() -> Student{
        var bob = Student(name:"BOB")
        let loginInfo:KeyValuePairs = [
            "email": "bobby@gmail.com",
            "password": "2893uewjdnk"
        ]
        let musicalBackground:KeyValuePairs = [
            "Instrument": "Cello",
            "Years Playing": "12",
            "Skill Level": "Advanced",
            "Prior Pieces Played": "Bagatelle 12 by Beethoven",
            "Budget": "$80 per lesson"
        ]
        let studentInfo:KeyValuePairs = [
            "name": "Bobby Schneider",
            "age": "10"

        ]
        bob.populateInfo(personalInfo: studentInfo, loginInfo: loginInfo, musicalBackground: musicalBackground)
        return bob
    }

//    public func getImage() -> Image{
//        let image = Image("blankperson")
//
//        return profileImage?.image ?? image
//    }
    public func getUIImage() -> UIImage{
        print("GETTING THE UI IMAGE ")
        let image = UIImage(systemName: "person.fill")
        return uiImage ?? image!
    }
    public mutating func setUIImage(uiImage: UIImage){
        self.uiImage = uiImage 
    }

    func getStringProperty(key: String, pairs: KeyValuePairs<String, String>) -> String {
        if let index = pairs.firstIndex(where: { $0.0 == key }) {
            print("KEY: " + key + " VALUE: " + pairs[index].value)
            return pairs[index].value
        } else {
            return ""
        }
    }
    func getDoubleProperty(key: String, pairs: KeyValuePairs<String, String>) -> Double{
        let stringValue = getStringProperty(key: key, pairs: pairs)
        if let doubleValue = Double(stringValue) {
            return doubleValue
        } else {
            return 0
        }
    }
}
