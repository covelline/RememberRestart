import SwiftUI

struct AboutSettingView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var body: some View {
        Form {
            HStack {
                Image(.app)
                    .resizable()
                    .frame(width: 128, height: 128)
                VStack(alignment: .leading) {
                    Text(verbatim: "Remember Restart")
                        .font(.title)
                    Text("Version: \(appVersion)")
                        .foregroundColor(.secondary)

                    Link(String("covelline, LLC"), destination: URL(string: "https://covelline.com/")!)
                        .foregroundColor(.accentColor)
                    Link(String("GitHub Repository"), destination: URL(string: "https://github.com/covelline/RememberRestart")!)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

#Preview {
    AboutSettingView()
}
