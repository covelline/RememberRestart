import SwiftUI

struct MenuContentView: View {
    @EnvironmentObject private var uptime: Uptime

    var body: some View {
        VStack {
            Text(uptime.uptimeLong)
            Divider()
            if #available(macOS 14.0, *) {
                SettingsLink {
                    Label("Settings...", systemImage: "gear")
                }
            } else {
                Button(
                    action: {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                        for window in NSApp.windows {
                            if window.canBecomeMain {
                                window.orderFrontRegardless()
                            }
                        }
                    },
                    label: {
                        Label("Settings...", systemImage: "gear")
                    }
                )
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

#Preview {
    MenuContentView()
}
