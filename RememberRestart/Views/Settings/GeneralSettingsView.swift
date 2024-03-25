import LaunchAtLogin
import SwiftUI
import UserNotifications

struct GeneralSettingsView: View {
    @EnvironmentObject private var uptime: Uptime
    @EnvironmentObject private var notificationManager: NotificationManager
    @AppStorage(StorageKey.notifyWhenUptimeExceeds) private var notifyWhenUptimeExceeds: Bool = false
    @AppStorage(StorageKey.timelimitDays) private var timelimitDays = StorageKey.timelimitDaysDefaultValue // 1 week
    @AppStorage(StorageKey.menuBarStyle) private var menuBarStyle: MenuBarStyle = .uptimeAndIcon
    @State private var error: Error? = nil
    @FocusState private var focus

    private var isPassed: Bool {
        let uptime = uptime.uptimeValue
        let timeInterval = TimeInterval(timelimitDays * 24 * 60 * 60)
        return uptime > timeInterval
    }

    private let numberFormatter = NumberFormatter()
    var body: some View {
        Form {
            launchSettings

            notificationSettings

            appearanceSettings
        }
        .formStyle(.grouped)
        // notifyWhenUptimeExceedsがtrueになったら通知の許可をリクエストする
        .onChange(of: notifyWhenUptimeExceeds) { newValue in
            if newValue {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if let error = error {
                        self.error = error
                        notifyWhenUptimeExceeds = false
                        return
                    }
                    notifyWhenUptimeExceeds = granted
                }
            }
        }
        .onChange(of: timelimitDays) { _ in
            notificationManager.updateNotification(days: timelimitDays, currentUptime: uptime.uptimeValue)
        }
    }

    @ViewBuilder
    private var launchSettings: some View {
        Section(content: {
            LaunchAtLogin.Toggle {
                Text("Launch \"Remember Restart\" at login")
            }
        }, header: {
            Text("Startup")
                .font(.headline)
        })
    }

    @ViewBuilder
    private var notificationSettings: some View {
        Section(content: {
            Toggle("Enable Notification", isOn: $notifyWhenUptimeExceeds)
            HStack {
                Text("Notify after")
                HStack(spacing: 0) {
                    TextField(String(""), value: $timelimitDays, formatter: numberFormatter)
                        .frame(width: 100)
                        .focused($focus)
                    Stepper(String(""), value: $timelimitDays, in: 1 ... 100, step: 1) { _ in
                        focus = false
                    }
                }
                Text("days after your computer is activated.")
                Spacer()
            }
            .lineLimit(1)
            .labelsHidden()
            if isPassed {
                Text("The specified deadline has passed.")
                    .foregroundColor(.red)
            } else {
                // 通知予定時刻を絶対時刻で表示
                let firedate = Date(timeIntervalSinceNow: TimeInterval(timelimitDays * 24 * 60 * 60) - uptime.uptimeValue).formatted(date: .long, time: .standard)
                Text("The notification will display at \(firedate)")
                    .foregroundColor(.secondary)
            }
        }, header: {
            Text("Notification")
                .font(.headline)
        })
    }

    @ViewBuilder
    private var appearanceSettings: some View {
        Section(content: {
            Picker("MenuBarStyle.title", selection: $menuBarStyle) {
                Text("MenuBarStyle.uptimeAndIcon").tag(MenuBarStyle.uptimeAndIcon)
                Text("MenuBarStyle.iconOnly").tag(MenuBarStyle.iconOnly)
                Text("MenuBarStyle.uptimeOnly").tag(MenuBarStyle.uptimeOnly)
            }
            .pickerStyle(.menu)

        }, header: {
            Text("Appearance")
                .font(.headline)
        })
    }
}

#Preview {
    GeneralSettingsView()
        .environmentObject(Uptime())
}
