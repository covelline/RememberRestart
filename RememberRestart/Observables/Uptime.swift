import Combine
import Foundation

@MainActor
final class Uptime: ObservableObject {
    @Published private(set) var uptime: String = "-"
    @Published private(set) var uptimeLong: String = "-"
    @Published private(set) var uptimeValue: TimeInterval = 0

    private var timer: Timer?

    init() {
        updateUptime()
        scheduleTimer()
    }

    private func scheduleTimer() {
        let interval: TimeInterval
        if uptimeValue < 60 {
            interval = 1
        } else {
            interval = 60
        }

        timer?.invalidate()
        timer = .scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in
            Task {
                await MainActor.run { [weak self] in
                    self?.updateUptime()
                    self?.scheduleTimer()
                }
            }
        })
    }

    private func updateUptime() {
        var time = timespec()
        guard clock_gettime(CLOCK_MONOTONIC_RAW, &time) == 0 else {
            return
        }
        uptimeValue = TimeInterval(time.tv_sec)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.maximumUnitCount = 1
        uptime = formatter.string(from: uptimeValue) ?? "-"

        formatter.maximumUnitCount = 3
        uptimeLong = formatter.string(from: uptimeValue) ?? "-"
    }
}
