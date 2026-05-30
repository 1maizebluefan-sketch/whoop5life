# WHOOP 5.0 / MG / Life Bluetooth Compatibility

Status: implementation scaffold, safe standard-BLE support, no proprietary app assets.

## What ships in this branch

The iOS app now scans for WHOOP devices advertising either the known custom service or
standard BLE Heart Rate / Battery services. It infers WHOOP 4.0, 5.0, MG, and Life from
the advertised local name, shows the detected model in the Device screen, and falls back
to standard BLE mode when the custom protocol is unavailable or unverified.

## Feature matrix

| Feature | 4.0 custom protocol | 5.0 / MG / Life standard BLE | Notes |
|---|---:|---:|---|
| Live heart rate | Yes | Yes | Standard `0x2A37` is the compatibility path. |
| R-R intervals / HRV input | Yes | Yes, when broadcast includes RR | Used for local HRV and recovery estimates. |
| Battery percent | Yes | Yes | Standard `0x2A19`. |
| Historical backfill | Yes | Not yet | Needs owner-captured 5.0/MG/Life protocol traces. |
| Raw IMU / optical | 4.0 experimental | Not yet | Do not assume 4.0 offsets apply to 5.0/MG/Life. |
| Haptics / alarms | 4.0 experimental | Not yet | Keep writes disabled until verified. |
| ECG / IHRN | No | No | Regulated Life/MG feature, not emitted as local BLE data here. |
| Labs / clinician / AI coaching | No | No | Cloud/service features, not Bluetooth protocol features. |

## Protocol rules

1. Standard BLE is always safe to read: Heart Rate Service `0x180D`, Heart Rate
   Measurement `0x2A37`, Battery Service `0x180F`, Battery Level `0x2A19`.
2. Custom writes stay limited to the verified 4.0 command set. If a 5.0/MG/Life device
   exposes a similar service, the app should log it but avoid write-side actions until
   independent owner-captured tests confirm payload compatibility.
3. New 5.0/MG/Life decoders must be added as schema versions in `protocol/whoop_protocol.json`
   and synced into the Swift and Python packages so parity tests keep all consumers aligned.
4. User-visible Life features should be labeled by data source: local BLE, local estimate,
   server estimate, or external/official service. Do not present regulated or cloud-derived
   features as if they were locally decoded from Bluetooth.

## Next verification

Use a real WHOOP 5.0/MG/Life device with HR Broadcast enabled. Confirm the app discovers
the device, shows `Standard BLE`, receives HR/R-R notifications, and updates battery
without bonding or custom writes. Only after that should custom-service captures be
collected for schema work.
