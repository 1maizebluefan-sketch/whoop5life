import SwiftUI

struct LifeView: View {
    @EnvironmentObject private var metrics: MetricsRepository

    var body: some View {
        ZStack {
            WH.Color.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: WH.Spacing.md) {
                    ScreenHeader("Life")
                    readinessGrid
                    healthMonitorGrid
                    externalServices
                }
                .padding(WH.Spacing.md)
            }
            .refreshable { await metrics.refresh() }
        }
        .preferredColorScheme(.dark)
        .task {
            await metrics.load()
            if metrics.today == nil { await metrics.refresh() }
        }
    }

    private var readinessGrid: some View {
        VStack(alignment: .leading, spacing: WH.Spacing.sm) {
            sectionHeader("Readiness")
            HStack(spacing: WH.Spacing.sm) {
                MetricCard(
                    title: "Recovery",
                    value: metrics.today?.recovery.map { String(format: "%.0f", $0 * 100) } ?? "-",
                    unit: metrics.today?.recovery == nil ? nil : "%",
                    accentColor: metrics.today?.recovery
                        .map { WH.Color.recoveryColor(forPercent: $0 * 100) } ?? WH.Color.textSecondary
                )
                MetricCard(
                    title: "Strain",
                    value: metrics.today?.strain.map { String(format: "%.1f", $0) } ?? "-",
                    accentColor: metrics.today?.strain == nil ? WH.Color.textSecondary : WH.Color.strainBlue
                )
            }
            HStack(spacing: WH.Spacing.sm) {
                MetricCard(
                    title: "HRV",
                    value: (metrics.today?.avgHrv ?? metrics.lastNight?.avgHrv)
                        .map { String(format: "%.0f", $0) } ?? "-",
                    unit: (metrics.today?.avgHrv ?? metrics.lastNight?.avgHrv) == nil ? nil : "ms",
                    accentColor: (metrics.today?.avgHrv ?? metrics.lastNight?.avgHrv) == nil
                        ? WH.Color.textSecondary : WH.Color.teal
                )
                MetricCard(
                    title: "Resting HR",
                    value: (metrics.today?.restingHr ?? metrics.lastNight?.restingHr)
                        .map { "\($0)" } ?? "-",
                    unit: (metrics.today?.restingHr ?? metrics.lastNight?.restingHr) == nil ? nil : "bpm",
                    accentColor: (metrics.today?.restingHr ?? metrics.lastNight?.restingHr) == nil
                        ? WH.Color.textSecondary : WH.Color.textPrimary
                )
            }
        }
    }

    private var healthMonitorGrid: some View {
        VStack(alignment: .leading, spacing: WH.Spacing.sm) {
            sectionHeader("Health Monitor")
            HStack(spacing: WH.Spacing.sm) {
                MetricCard(
                    title: "SpO2",
                    value: metrics.today?.spo2Pct.map { String(format: "%.1f", $0) } ?? "-",
                    unit: metrics.today?.spo2Pct == nil ? nil : "%",
                    accentColor: metrics.today?.spo2Pct == nil ? WH.Color.textSecondary : WH.Color.textPrimary
                )
                MetricCard(
                    title: "Respiratory",
                    value: metrics.today?.respRateBpm.map { String(format: "%.1f", $0) } ?? "-",
                    unit: metrics.today?.respRateBpm == nil ? nil : "/min",
                    accentColor: metrics.today?.respRateBpm == nil ? WH.Color.textSecondary : WH.Color.strainBlue
                )
            }
            MetricCard(
                title: "Skin Temp",
                value: metrics.today?.skinTempDevC.map { String(format: "%+.1f", $0) } ?? "-",
                unit: metrics.today?.skinTempDevC == nil ? nil : "C",
                accentColor: metrics.today?.skinTempDevC == nil ? WH.Color.textSecondary : WH.Color.recoveryYellow
            )
        }
    }

    private var externalServices: some View {
        VStack(alignment: .leading, spacing: WH.Spacing.sm) {
            sectionHeader("Life Services")
            serviceRow("ECG", status: "Official service")
            serviceRow("Irregular Rhythm", status: "Official service")
            serviceRow("Labs", status: "External")
            serviceRow("Clinician", status: "External")
            serviceRow("AI Coach", status: "External")
        }
        .padding(WH.Spacing.md)
        .background(WH.Color.surface, in: RoundedRectangle(cornerRadius: WH.Radius.card, style: .continuous))
    }

    private func sectionHeader(_ label: String) -> some View {
        Text(label.uppercased())
            .font(WH.Font.cardTitle)
            .foregroundStyle(WH.Color.textSecondary)
            .tracking(1.5)
    }

    private func serviceRow(_ label: String, status: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(WH.Color.textPrimary)
            Spacer()
            Text(status)
                .font(WH.Font.caption)
                .foregroundStyle(WH.Color.textSecondary)
        }
        .padding(.vertical, WH.Spacing.xs)
    }
}

#Preview("Life") {
    LifeView()
        .environmentObject(MetricsRepository(deviceId: "preview"))
}
