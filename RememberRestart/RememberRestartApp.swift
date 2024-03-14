import SwiftUI

@main
struct RememberRestartApp: App {
    @StateObject private var uptime: Uptime
    @StateObject private var notificationManager: NotificationManager
    @AppStorage(StorageKey.menuBarStyle) private var menuBarStyle: MenuBarStyle = .uptimeAndIcon

    init() {
        let uptime = Uptime()
        let notificationManager = NotificationManager()
        _uptime = .init(wrappedValue: uptime)
        _notificationManager = .init(wrappedValue: notificationManager)
        let notifyWhenUptimeExceeds: Bool = UserDefaults.standard.bool(forKey: StorageKey.notifyWhenUptimeExceeds)

        if notifyWhenUptimeExceeds {
            let timelimitDays: Int = UserDefaults.standard.integer(forKey: StorageKey.timelimitDays)
            notificationManager.updateNotification(days: timelimitDays, currentUptime: uptime.uptimeValue)
        }
    }

    var body: some Scene {
        MenuBarExtra(
            content: {
                MenuContentView()
                    .environmentObject(uptime)
                    .environmentObject(notificationManager)
            },
            label: {
                menuBarLabel
            }
        )
        Settings {
            SettingsView()
                .environmentObject(uptime)
                .environmentObject(notificationManager)
        }
        .windowResizability(.contentSize)
    }

    @ViewBuilder
    private var menuBarLabel: some View {
        switch menuBarStyle {
        case .uptimeAndIcon:
            Label(uptime.uptime, systemImage: "clock")
                .labelStyle(.titleAndIcon)
        case .iconOnly:
            Label(uptime.uptime, systemImage: "clock")
                .labelStyle(.iconOnly)
        case .uptimeOnly:
            Label(uptime.uptime, systemImage: "clock")
                .labelStyle(.titleOnly)
        }
    }
}
