# Devnet Validation Gate — Foundation v0.1

**State: BLOCKED — no verified devnet deployment.** The local CI passes on commit `b67a631945ac46be33ac7a51c8072ecf36d2d7e8` (runs 38140763695 and 38140760999), including 16/16 integration tests.

## Critical identity separation
Local CI runs `anchor keys sync` using **ephemeral program keypairs**, so local addresses differ across CI jobs. These local identities **must not** be treated as canonical devnet program IDs. The values currently in `Anchor.toml` under `[programs.devnet]` are not verified deployments.

Before any devnet command:
1. Provision two **persistent**, separately backed-up Solana program keypairs for `lab_core` and `attestation_engine` using a controlled offline/key-management process. Never commit their secret JSON files, log their contents, or paste them into chat.
2. Select a dedicated, restricted devnet deployer/upgrade-authority wallet, distinct from local CI's ephemeral wallet. Fund it only with testnet SOL as needed; devnet SOL has no monetary value.
3. Independently derive and record public keys from each program keypair; align both `declare_id!` source values and `Anchor.toml [programs.devnet]` with the **same reviewed public addresses**, without running an uncontrolled `anchor keys sync` against devnet configuration.
4. Confirm the build target and validator/cluster compatibility; compile the reviewed commit and validate both SBF ELF artifacts.
5. Require deliberate authorization for devnet deployment. Secrets should be supplied only via an approved protected secret store (e.g. restricted GitHub environment secrets), never repository files or command-line arguments that expose secret content.

## Evidence required — all must PASS
- **Identity:** Devnet public program IDs match the reviewed source and the persistent program keypairs.
- **Deployment:** Both programs are deployed to Solana **devnet**, with verifiable transaction signatures and finalized confirmation.
- **Ownership/authority:** Onchain program account is owned by the expected upgradeable loader, is executable, and the ProgramData upgrade authority matches the approved wallet.
- **Core:** A real devnet `initialize` transaction is finalized and its config PDA reads back the correct authority, version, and active status.
- **Attestation:** A devnet attestation is created and revoked by its issuer. Confirm the PDA, subject, immutable evidence hash and revoked state by RPC reads.
- **Adversarial behavior:** Invalid version/schema/evidence and unauthorized status change/revocation are rejected for the *expected* reasons (not missing programs or RPC failures).
- **Provenance:** Store devnet RPC endpoint/cluster, git commit, program IDs, transaction signatures, slots, read-back account addresses, upgrade authority, test output, and an UTC timestamp in a reviewed evidence report. **No private keys or confidential payloads** in evidence.

## Release lock
`LOCAL PASS → DEVNET EVIDENCE PASS → FOUNDATION REVIEW → RELEASE PASS`.

Do not mark Foundation PASS, merge PR #1 into `main`, deploy to mainnet, or start Risk Passport until the evidence above has been independently verified. Keep PR #1 Draft.

## CI policy
The existing push/PR workflow performs **local tests only**. It must never deploy to devnet from an untrusted pull request or with ephemeral local CI keys. A separate manual devnet workflow must have protected environment approval and explicit controls against accidental mainnet use before any secrets or transactions are enabled.
