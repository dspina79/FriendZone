//
//  Int-TimeFormatting.swift
//  FriendZone2
//
//  Created by Dave Spina on 3/13/21.
//

import Foundation

extension Int {
    func timeString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .positional
        
        var formattingString = formatter.string(from: TimeInterval(self)) ?? "0"
        if self > 0 {
            formattingString = "+ " + formattingString
        } else if self == 0 {
            formattingString = "0:00 GMT"
        }
        return formattingString
    }
}
