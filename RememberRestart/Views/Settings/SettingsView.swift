import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .id(Tab.general)
            AboutSettingView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .id(Tab.about)
                .frame(minWidth: 600, minHeight: 400)
        }
        .padding(20)
    }
}

extension SettingsView {
    enum Tab: Hashable {
        case general
        case about
    }
}

#Preview {
    SettingsView()
        .environmentObject(Uptime())
}
