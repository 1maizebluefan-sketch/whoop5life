# Protocol — canonical decode schema

`whoop_protocol.json` is the single source of decode truth for WHOOP 4.0 custom frames: the
packet-type / command / event enum tables, per-packet field layout (offset, dtype, name,
category), and the type-43 IMU/optical variant offsets. **Edit only this file to improve decode.**

WHOOP 5.0 / MG / Life currently use the app's standard-BLE compatibility path for HR,
R-R, and battery. Do not copy 4.0 custom offsets to those models without verified captures;
add new schema versions once owner-captured traces prove the layout.

Consumers (must never drift):
- `../Packages/WhoopProtocol/Sources/WhoopProtocol/Resources/whoop_protocol.json` — a copy
  bundled into the Swift package; test `SchemaSyncTests` asserts it is byte-identical to this file.
- The home-server `whoop-protocol` Python package — a vendored copy synced via
  `../scripts/sync-schema.sh`, guarded by the server's own parity test.

After editing this file: run `scripts/sync-schema.sh`, then run both test suites.
