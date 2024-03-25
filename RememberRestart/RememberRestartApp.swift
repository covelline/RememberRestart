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
            label
                .labelStyle(.titleAndIcon)
        case .iconOnly:
            label
                .labelStyle(.iconOnly)
        case .uptimeOnly:
            label
                .labelStyle(.titleOnly)
        }
    }

    @ViewBuilder
    private var label: some View {
        Label(
            title: {
                #if DEBUG
                    Text(verbatim: "\(uptime.uptime) dev")
                #else
                    Text(uptime.uptime)
                #endif

            },
            icon: {
                menuBarIcon
            }
        )
    }

    private var menuBarIcon: Image {
        // https://stackoverflow.com/a/77263538
        guard let image = NSImage(named: "icon") else { fatalError("icon not found.") }
        let ratio = image.size.height / image.size.width
        let size: CGFloat = 21
        image.size.height = size
        image.size.width = size / ratio
        return Image(nsImage: image)
    }
}
