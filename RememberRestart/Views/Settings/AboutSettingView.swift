import SwiftUI

struct AboutSettingView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        Form {
            HStack {
                VStack(alignment: .leading) {
                    Text(verbatim: "Remember Restart")
                        .font(.title)
                    Text("Version: \(appVersion)")
                        .foregroundColor(.secondary)
                }
            }
            HStack {
                Link(String("covelline, LLC"), destination: URL(string: "https://covelline.com/")!)
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    AboutSettingView()
}
