//
//  Teacher.swift
//  MusicAppSeniorProject
//
//  Created by Samuel Wang on 2/23/23.
//

import Foundation
import SwiftUI
import CoreLocation

struct Teacher:Identifiable{
    static func == (lhs: Teacher, rhs: Teacher) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
    let id = UUID()
    var name: String
    var firstName: String = ""
    var yearsExperience: Int = 0
    var lastName: String = ""
    var instrument: String = ""
    var lessonType: String = ""
    var lessonLength: String = ""
    var priceRange: String = ""
    var email: String = ""
    var password: String = ""
    var aboutDescription: String = ""
    var imageName: String = ""
    var image: Image{
        Image(imageName)
    }
    var uid: String = "NULL"
    
    var loginInfo:KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("", ""))
    var musicalBackground:KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("", ""))
    var lessonInfo:KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("", ""))
    var teacherInfo:KeyValuePairs = KeyValuePairs(dictionaryLiteral: ("", ""))

    mutating func populateInfo(firstName: String, lastName: String, lessonType: String, priceRange: String, email: String, password: String, instrument: String){
        self.firstName = firstName
        self.lastName = lastName
        self.lessonType = lessonType;
        self.priceRange = priceRange;
        self.email = email
        self.password = password
        self.instrument = instrument
    }
    mutating func populateInfo(teacherInfo:KeyValuePairs<String, String>, loginInfo:KeyValuePairs<String, String>, musicalBackground:KeyValuePairs<String, String>, lessonInfo: KeyValuePairs<String, String>){
        self.teacherInfo = teacherInfo
        self.loginInfo = loginInfo
        self.musicalBackground = musicalBackground
        self.lessonInfo = lessonInfo
    }
    mutating func setUID(uid: String){
        self.uid = uid
    }
    static func createGenericTeacher() -> Teacher{
        var bob = Teacher(name:"BOB")
        let loginInfo:KeyValuePairs = [
            "email": "genericteacher@gmail.com",
            "password": "DF"
        ]
        let musicalBackground:KeyValuePairs = [
            "Instrument": "Cello",
            "Years Teaching": String(12),
            "Musical Degree": "Peabody School of Music",
            "Teaching Style": "Peaceful Harmony",
        ]
        var customPricing = true
        let cost = customPricing ? "Contact for info" : String(" 12 per lesson")
        let lessonInfo:KeyValuePairs = [
            "Lesson Length": String(60),
            "Pricing": cost,
            "Minimum Student Level": "Beginner",
        ]
        let name = "Generic Teacher"
        let teacherInfo:KeyValuePairs = [
            "name": name,
            "firstName": "Generic",
            "lastName": "Teacher"
        ]
        bob.populateInfo(teacherInfo: teacherInfo, loginInfo: loginInfo, musicalBackground: musicalBackground, lessonInfo: lessonInfo)
        return bob
        
    }

}
