//
//  NotificationView.swift
//  Forgive Yourself
//
//  Created by Michael Ensly on 8/2/21.
//

import SwiftUI
import UserNotifications

private func loadTime() -> Date {
    let saved = UserDefaults.standard.double(forKey: KEY_NOTIF_TIME)
    if saved > 0 { return Date(timeIntervalSince1970: saved) }
    let cal = Calendar(identifier: .gregorian)
    var dateComponents = DateComponents()
    dateComponents.calendar = cal
    dateComponents.year = (dateComponents.year ?? 2021) + 1
    dateComponents.month = 1
    dateComponents.day = 1
    dateComponents.hour = 12
    dateComponents.minute = 0
    dateComponents.second = 0
    return cal.date(from: dateComponents) ?? Date()
}

private func getDateFormat() -> DateFormatter {
    let dateFormat = DateFormatter()
    dateFormat.dateStyle = .short
    dateFormat.timeStyle = .short
    return dateFormat
}

func isNotificationEnabled() -> Bool {
    return UserDefaults.standard.string(forKey: KEY_NOTIF_ID) != nil
}

struct NotificationView: View {
    @State private var notificationEnabled = isNotificationEnabled()
    @State private var id = UserDefaults.standard.string(forKey: KEY_NOTIF_ID) ?? UUID().uuidString
    @State private var time = loadTime()
    
    var body: some View {
        let enabledBinding = Binding<Bool> { () -> Bool in
            self.notificationEnabled
        } set: { (enabled) in
            self.notificationEnabled = enabled
            if enabled {
                id = UUID().uuidString
                UserDefaults.standard.set(id, forKey: KEY_NOTIF_ID)
            }
            else {
                UserDefaults.standard.removeObject(forKey: KEY_NOTIF_ID)
                UserDefaults.standard.removeObject(forKey: KEY_NOTIF_TIME)
            }
            configureNotification()
        }
        let timeBinding = Binding<Date> { () -> Date in
            self.time
        } set: { (time) in
            self.time = time
            configureNotification()
        }

        
        VStack() {
            Toggle("Enable Notification", isOn: enabledBinding)
            DatePicker(selection: timeBinding, in: PartialRangeFrom(Date())) {
                Text("Time")
            }
            Text("Try to clear the list once a year. Maybe New Year, your birthday, Chinese New Year, Ramadan, or Yom Kippur.")
            Spacer()
        }.padding(EdgeInsets(top: PADDING, leading: PADDING,
                             bottom: PADDING, trailing: PADDING))
        .navigationBarTitle("Notifications")
    }
    
    private func configureNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        if (notificationEnabled) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    let content = UNMutableNotificationContent()
                    content.title = "It is time to forgive yourself"
                    content.sound = UNNotificationSound.default
                    
                    let cal = Calendar(identifier: .gregorian)
                    let triggerDate = cal.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: time)
                    let trigger = UNCalendarNotificationTrigger(dateMatching:triggerDate, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if error == nil {
                            UserDefaults.standard.set(time.timeIntervalSince1970, forKey: KEY_NOTIF_TIME)
                        }
                        else {
                            notificationEnabled = false
                            print(error!.localizedDescription)
                        }
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
