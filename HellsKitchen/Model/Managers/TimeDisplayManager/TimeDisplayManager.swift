//
//  TimeDisplayManager.swift
//  HellsKitchen
//
//  Created by Apple on 03/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

class TimeDisplayManager {
    static let shared = TimeDisplayManager()
    
    private init() {}
    
    func getDateForUserCell(timestamp: Double)-> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return getDaysComponent(for: date)
    }
    
    func getDateForMessageCell(timestamp: Double)-> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let daysComponent = getDaysComponent(for: date)
        let hourComponent =  " \(date)"[11..<17]
        return "Sent •" + daysComponent + hourComponent
    }
    
    func getDateForPostCell(timestamp: Double)-> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let currentTimestamp = Date().timeIntervalSince1970
        let diff = currentTimestamp - timestamp
        
        if diff < 60 {
            return "less than 1 minute ago"
        }
        
        if diff < 120 {
            return "1 minute ago"
        }
        
        if diff < 3600 {
            return "\(Int(diff/60.0)) minutes ago"
        }
        
        if diff < 7200 {
            return "1 hour ago"
        }
        
        if diff < 86400 {
            return "\(Int(diff/3600.0)) hours ago"
        }
        return getDaysComponent(for: date)
    }
    
    private func getDaysComponent(for date: Date)-> String {
        let calendar = Calendar.current
        var daysComponent = ""
        if calendar.isDateInToday(date) {
            daysComponent = " Today"
        } else if calendar.isDateInYesterday(date){
            daysComponent = " Yesterday"
        } else {
            daysComponent = " \(date)"[0..<11].replacingOccurrences(of: "-", with: ".")
        }
        return daysComponent
    }
    
}
