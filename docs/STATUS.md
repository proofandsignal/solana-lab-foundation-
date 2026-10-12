# Foundation Status

| Gate | Status |
|---|---|
| Source scaffold | ✅ |
| Core v0.1 source | ✅ |
| Attestation v0.1 source | ✅ |
| 16-test suite authored | ✅ |
| Compile | ✅ Local CI, commit `b67a6319` |
| 16 tests executed | ✅ 16/16 on local validator, both CI runs |
| Clippy | ✅ `-D warnings` in both CI runs |
| Local Validator | ✅ Both programs deployed locally and tested |
| Devnet | ⬜ BLOCKED: persistent program identities and verified onchain evidence required |
| Foundation PASS | ⬜ |
| Risk Passport v0.1 unlocked | ⬜ |

## Commercial policy
Risk Passport initial paid production hypothesis: **$0.50 / scan/proof**.

## Rule
Do not change a failed gate to PASS without evidence.

## Verified local CI evidence
- Commit: `b67a631945ac46be33ac7a51c8072ecf36d2d7e8`.
- Runs: https://github.com/proofandsignal/solana-lab-foundation-/actions/runs/38140763695 and https://github.com/proofandsignal/solana-lab-foundation-/actions/runs/38140760999 — both success; 16 passing each.
- Local CI program keys are ephemeral and vary across runs; **not devnet deployment identities**.
- Devnet gate and evidence checklist: [DEVNET_GATE.md](DEVNET_GATE.md).
- PR #1 must remain Draft and unmerged until all release gates PASS.
