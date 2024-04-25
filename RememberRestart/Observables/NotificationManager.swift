import Foundation
import UserNotifications

@MainActor
final class NotificationManager: ObservableObject {
    private let notificationRequestIdentifier = "com.covelline.RememberRestart"

    /// 指定したdays後に通知を発行する.
    func updateNotification(days: Int, currentUptime: TimeInterval) {
        guard !ProcessInfo.processInfo.isRunningForPreviews else { return }
        cancelNotification()

        let content = createNotificationContent(days: days)
        let timeInterval = TimeInterval(days * 24 * 60 * 60) - currentUptime
        guard timeInterval > 0 else {
            let request = UNNotificationRequest(identifier: notificationRequestIdentifier, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)
            return
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: notificationRequestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationRequestIdentifier])
    }
}

extension NotificationManager {
    func createNotificationContent(days: Int) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "You have not restarted for \(days) days.")
        content.body = String(localized: "Notification-body")
        content.sound = .default

        return content
    }
}
