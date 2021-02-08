//
//  Forgive_YourselfApp.swift
//  Forgive Yourself
//
//  Created by Michael Ensly on 7/2/21.
//

import SwiftUI

@main
struct Forgive_YourselfApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        let notificationTime = UserDefaults.standard.double(forKey: KEY_NOTIF_TIME)
        if notificationTime < Date().timeIntervalSince1970 {
            let cal = Calendar(identifier: .gregorian)
            var dateComponents = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(timeIntervalSince1970: notificationTime))
            dateComponents.calendar = cal
            dateComponents.year = (dateComponents.year ?? 2021) + 1
            UserDefaults.standard.set(cal.date(from: dateComponents)?.timeIntervalSince1970, forKey: KEY_NOTIF_TIME)
        }
    }
}
