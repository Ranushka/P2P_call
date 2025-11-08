# P2P Call Implementation Blueprint & Progress Tracker

This repository manages the execution plan for the link-based peer-to-peer calling application. The README serves as a living source of truth for scope, sequencing, risks, and progress so that engineering, product, and QA stay aligned as delivery advances.

---

## 1. Vision & Success Criteria

**Product Goal**
> Ship a Flutter-based mobile experience that lets anyone create or join multi-party audio/video calls through a shareable room link without requiring authentication.

**Success Metrics**
- ✅ Create → share → join flow completes on fresh installs in under 60 seconds.
- ✅ 10 participants can maintain a stable video call for 20 minutes on mid-range Android/iOS hardware.
- ✅ Incoming call notifications succeed (push + ringtone) for at least 95% of attempts in beta.
- ✅ Diagnostics export enables support to triage user issues without reproducing locally.

**Non-Goals for V1**
- ❌ Desktop or web targets.
- ❌ Federation with external identity providers.
- ❌ Server-side recording or transcription.

---

## 2. Architecture Snapshot

| Layer | Technology | Responsibilities |
| --- | --- | --- |
| UI & State | Flutter (Riverpod recommended) | Screens, navigation, state restoration, dependency injection. |
| Signaling & Presence | Firebase Realtime Database | Room metadata, participant roster, WebRTC offer/answer/ICE payloads. |
| Notifications | Firebase Cloud Messaging + `flutter_local_notifications` | Push delivery, ringtone playback, incoming call UX. |
| Media | WebRTC (`flutter_webrtc`) | Peer connection lifecycle, track management, diagnostics. |
| Storage | Secure storage (Keychain/Keystore) + Hive | Config secrets, joined-room cache, logs. |
| Networking | STUN (`stun.l.google.com:19302`) + configurable TURN | NAT traversal, bandwidth policy. |

**Cross-Cutting Concerns**
- Configuration profiles (`dev` / `stage` / `prod`) toggled at runtime.
- Diagnostics surface: echo test, log export, RTC stats overlay.
- Background modes: iOS VoIP push / Android foreground service for active calls.

---

## 3. Delivery Roadmap

### 3.1 Phase Timeline (assumes 1–2 engineers)

| Phase | Target Week | Exit Criteria | Notes |
| --- | --- | --- | --- |
| P0 – Bootstrap | Week 1 | Flutter project created, CI (format/analyze/test) passes, Firebase projects connected to Dev profile. | Capture secrets management approach and document onboarding. |
| P1 – Core Services | Week 2 | Room CRUD + participant sync in Firebase, local joined-room cache, settings persistence. | Include smoke tests for data models and signaling payloads. |
| P2 – WebRTC Foundations | Week 3 | Two devices exchange audio/video via Firebase signaling; mute/camera toggles wired. | Use TURN fallback to validate poor-network scenarios. |
| P3 – UX Flows | Week 4 | Home → Connecting → Call → Leave, Settings, Incoming Call screens implemented with navigation/state restore. | Accessibility pass for major controls. |
| P4 – Notifications & Background | Week 5 | Push notifications trigger ringtone + full-screen intent even when app closed; auto-join preference honored. | Test on physical devices (iOS/Android). |
| P5 – Quality & Release | Week 6 | Automated tests stable, diagnostics tools complete, release checklist approved. | Include beta distribution plan (Firebase App Distribution/TestFlight). |

### 3.2 Milestone Acceptance Checklist

Each milestone is complete only when **all** acceptance checks are satisfied.

- **P0 – Bootstrap**
  - [ ] Repository contains Flutter project skeleton with module structure.
  - [ ] GitHub Actions (or alternative CI) runs `flutter format`, `flutter analyze`, and sample tests.
  - [ ] Firebase projects configured for Dev/Stage/Prod with environment switching documented.
  - [ ] Secrets stored securely (dotenv variants excluded from VCS).

- **P1 – Core Services**
  - [ ] Data models (`GroupRoom`, `Participant`, `AppSettings`, `SignalingMessage`) created with JSON serialization and unit coverage.
  - [ ] Firebase service exposes create/join/list/update APIs with optimistic updates.
  - [ ] Joined-room cache persisted locally with migration strategy.
  - [ ] Settings service encapsulates secure config storage and validation.

- **P2 – WebRTC Foundations**
  - [ ] WebRTC service manages peer connection map and lifecycle hooks.
  - [ ] Local media (camera/mic) permission prompts handled gracefully.
  - [ ] Mesh call with 3+ simulated peers verified on staging TURN.
  - [ ] Diagnostics overlay displays bitrate, packet loss, and selected TURN/STUN.

- **P3 – UX Flows**
  - [ ] Home screen supports create, join via link, and history resume.
  - [ ] Connecting screen animates status, includes retry/backoff, and escalates errors.
  - [ ] Call screen renders adaptive grid/list with participant names and media controls.
  - [ ] Incoming call screen integrates with notification payload to deep link into call.
  - [ ] Settings screen surfaces Firebase, Notifications, Calling, Network, Privacy, Diagnostics subsections.

- **P4 – Notifications & Background**
  - [ ] Push tokens registered and refreshed per device/profile.
  - [ ] Local ringtone handled via `flutter_local_notifications` with Do Not Disturb schedule.
  - [ ] Background/terminated state acceptance validated (Android foreground service + iOS VoIP).
  - [ ] Auto-join toggle respected; decline flows properly stop media + ringtone.

- **P5 – Quality & Release**
  - [ ] Unit, widget, and integration test suites automated in CI.
  - [ ] Load/soak test completed for 10 participants with documented results.
  - [ ] Diagnostics export packages logs + RTC stats + device info.
  - [ ] Crash/error monitoring hooked (e.g., Sentry or Firebase Crashlytics).
  - [ ] Release readiness checklist signed (privacy policy, app store assets, beta rollout strategy).

---

## 4. Task Board (Living TODO)

Track progress by checking items as they complete. Subtasks may move between phases as needed.

### 4.1 Infrastructure & Tooling
- [ ] Initialize Flutter project with recommended folder structure (`lib/app`, `lib/features/...`).
- [ ] Configure flavors or build variants (Dev/Stage/Prod) with `flutter_dotenv` alternatives stored securely.
- [ ] Set up GitHub Actions workflow for format/analyze/test on PRs.
- [ ] Establish code quality gates (analysis warnings fail builds).
- [ ] Document onboarding steps in `docs/onboarding.md` (create file when ready).

### 4.2 Data & Signaling Services
- [ ] Define data models + serializers (use `freezed` + `json_serializable`).
- [ ] Firebase RTDB structure defined (`rooms/{roomId}`, `participants/{roomId}/{participantId}`, `signals/{roomId}`).
- [ ] Implement service layer with stream-based updates and optimistic UI support.
- [ ] Local persistence (Hive or Drift) for joined rooms + recent participants.
- [ ] Logging/analytics hooks for signaling events.

### 4.3 WebRTC & Media
- [ ] Integrate `flutter_webrtc` and handle permission flows.
- [ ] Abstract peer connection lifecycle (create offer/answer, ICE candidate exchange).
- [ ] Manage track toggles (mute, camera off) with UI feedback.
- [ ] Implement echo/loopback test for diagnostics screen.
- [ ] Monitor quality metrics (bitrate, RTT, packet loss) and expose via notifier.

### 4.4 User Experience & Navigation
- [ ] Home screen (create/join/history) with validation + link parsing.
- [ ] Deep link handler to route `app.com/room/{id}` to connecting flow.
- [ ] Connecting screen with cancellable progress + error states.
- [ ] Call screen supporting video grid + audio avatar layout, including active speaker highlight.
- [ ] Incoming call screen with accept/decline + auto-join toggle.
- [ ] Settings screen with tabs/sections (Firebase, Notifications, Calling, Network, Privacy, Diagnostics).
- [ ] State restoration so returning to app resumes correct call state.

### 4.5 Notifications & Background Handling
- [ ] Register device with FCM and manage token lifecycle + topic/room subscriptions.
- [ ] Build notification payload schema (roomId, caller, mode, autoJoin flag).
- [ ] Configure `flutter_local_notifications` for ringtone, DND schedule, custom sounds.
- [ ] Android foreground service for ongoing calls; iOS CallKit/PushKit integration if required.
- [ ] Validate background scenarios (app killed, device locked) for incoming calls.

### 4.6 Quality, Diagnostics & Release
- [ ] Unit tests for services (Firebase, signaling, settings persistence).
- [ ] Widget/integration tests for critical flows (create room, join via link, incoming call accept/decline).
- [ ] Performance/load test harness (simulate 10 participants exchanging media).
- [ ] Diagnostics export (logs, RTC stats, device info) accessible from Settings.
- [ ] Crash monitoring + analytics instrumentation (Crashlytics, Firebase Analytics).
- [ ] Release checklist covering store assets, privacy policy, beta distribution.

---

## 5. Quality Strategy

| Layer | Approach | Tooling |
| --- | --- | --- |
| Static Analysis | Enforce `flutter analyze`, `dart format`, optional `dart_code_metrics`. | CI + pre-commit hooks. |
| Unit Tests | Services, state notifiers, serialization. | `flutter test`, mocks/stubs via `mocktail`. |
| Widget Tests | Screen rendering, navigation flows. | `flutter test --tags=widget`. |
| Integration Tests | Device farm or Firebase Test Lab for end-to-end create/join/notify flows. | `flutter drive` / `integration_test`. |
| Load/Stress | Simulated peers using headless `flutter_webrtc` clients or Node-based test harness. | Custom scripts + Firebase emulator. |
| Monitoring | Crashlytics, analytics dashboards, log export review. | Firebase console. |

---

## 6. Risk Register

| Risk | Impact | Likelihood | Mitigation |
| --- | --- | --- | --- |
| WebRTC mesh scalability beyond 6–8 users | High | Medium | Validate with staged load tests early, consider TURN capacity upgrades, document fallback to audio-only. |
| Background notification restrictions (OEM variants) | Medium | High | Maintain OEM-specific guides, leverage high-priority FCM, provide in-app reminders to whitelist app. |
| Secure handling of Firebase credentials | High | Medium | Store secrets via secure storage, gate editing behind authentication in Settings, avoid bundling production keys in app build. |
| Platform permission UX friction | Medium | Medium | Provide contextual rationale screens before OS prompts, add fallback contact support flow. |
| TURN server costs/outages | Medium | Low | Monitor usage, configure multiple TURN providers, expose runtime overrides in Settings. |

---

## 7. Communication & Reporting

- Update this README weekly with progress notes (checked items, blockers, milestone status).
- Maintain sprint notes in `/docs/changelog.md` (to be created when work starts).
- Use GitHub Projects board linked to README checklists for day-to-day tracking.
- Flag risks/blockers in stand-ups and mirror them in Section 6.

---

## 7.5 Prototype Implementation Snapshot

The initial Flutter prototype in `/lib` focuses on core local user flows so the team can quickly iterate on UX before wiring up Firebase signaling, FCM, and WebRTC:

- `lib/app.dart` wires the `MaterialApp`, global theme, and registers named routes for the home, connecting, and call screens.
- `lib/features/groups` contains an in-memory `GroupController` to mimic room lifecycle actions (create, join by link, toggle active state) ahead of Firebase integration.
- `lib/features/home` surfaces room creation, joined-group listing, and link-based joins, mirroring the discovery experience defined in Section 4.1.
- `lib/features/call` includes a simulated connecting flow plus a call surface with placeholder tiles, mute/video toggles, and leave controls.

Run the following commands after installing the Flutter SDK locally:

```bash
flutter pub get
flutter run
```

Dependencies are intentionally minimal (`provider`, `uuid`) so subsequent sprints can layer networking, notifications, and diagnostics without heavy refactors.

---

## 8. Next Steps (Week 1 Focus)

1. ~~Stand up Flutter repository~~ → continue documenting onboarding and enable CI checks.
2. Finalize Firebase project structure + access (Dev/Stage/Prod) and confirm Realtime Database rules.
3. Spike on WebRTC integration (`flutter_webrtc`) to validate required permissions/build settings.
4. Draft notification payload schema and confirm FCM setup prerequisites.
5. Create `/docs/onboarding.md` and `/docs/architecture.md` placeholders for future detail.

_Update checkboxes as progress is made. Add dated progress notes below to provide historical context._

**Progress Log**
- 2024-06-05: Flutter prototype skeleton committed with in-memory room management, connecting flow, and call screen controls.
