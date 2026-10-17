# Devnet Identity Setup — Operator Runbook

**Scope:** devnet only. **No deployment is authorized by this document.** Keep PR #1 Draft and `main` unchanged until all gates are verified.

## Operator prerequisites
- Use WSL/Linux with a verified Solana CLI and Anchor toolchain.
- Work **outside the Git checkout** in a private, backed-up directory, e.g. `$HOME/.config/solana-lab/devnet`, with permissions `0700`.
- Choose a dedicated deployment/upgrade authority **distinct from the local CI wallet**. Manage backups offline. Never transmit private keys through chat, screenshots, GitHub issues, CI logs, or repository files.
- Do **not** copy the existing `Anchor.toml [programs.devnet]` addresses into an evidence report as if they were deployed.

## One-time key generation (operator's trusted machine only)
```bash
set -euo pipefail
umask 077
KEY_DIR="$HOME/.config/solana-lab/devnet"
mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"
test ! -e "$KEY_DIR/lab_core-keypair.json"
test ! -e "$KEY_DIR/attestation_engine-keypair.json"
test ! -e "$KEY_DIR/upgrade-authority.json"
solana-keygen new --no-bip39-passphrase --silent --outfile "$KEY_DIR/lab_core-keypair.json"
solana-keygen new --no-bip39-passphrase --silent --outfile "$KEY_DIR/attestation_engine-keypair.json"
solana-keygen new --no-bip39-passphrase --silent --outfile "$KEY_DIR/upgrade-authority.json"
chmod 600 "$KEY_DIR"/*.json
echo "Lab Core public ID: $(solana-keygen pubkey "$KEY_DIR/lab_core-keypair.json")"
echo "Attestation public ID: $(solana-keygen pubkey "$KEY_DIR/attestation_engine-keypair.json")"
echo "Upgrade authority public ID: $(solana-keygen pubkey "$KEY_DIR/upgrade-authority.json")"
```

**Stop after printing the three public keys.** Record these **public keys only** for review. Do not run `anchor keys sync` against the production repo: local CI dynamically creates keys and may replace IDs. Update `declare_id!` and `[programs.devnet]` only after public IDs have been reviewed. In particular, changing `declare_id!` also affects the local test suite, so rerun the full local gate after identity alignment.

## Devnet preflight (no deploy)
```bash
solana cluster-version --url https://api.devnet.solana.com
solana account "$(solana-keygen pubkey "$KEY_DIR/lab_core-keypair.json")" --url https://api.devnet.solana.com
solana account "$(solana-keygen pubkey "$KEY_DIR/attestation_engine-keypair.json")" --url https://api.devnet.solana.com
```
An unavailable account is expected for an unused ID. If an account already exists, stop and investigate owner, executable bit, and authority before proceeding. Always verify the RPC is **devnet**, never mainnet.

## Deployment authorization checklist
- Permanent public IDs recorded and reviewed.
- Private key backup/recovery procedure confirmed.
- Designated upgrade authority public ID approved.
- Post-alignment compile, SBF ELF, Clippy, and 16/16 local integration tests PASS.
- Deploy only through a separately approved/manual workflow with protected credentials and a reviewed commit.
- Capture finalized signatures, slots, executable program accounts, ProgramData/upgrade authority, Core PDA and attestation create/revoke read-backs; save redacted evidence in `docs/STATUS.md`.

**Release lock:** no PR merge, mainnet deployment, or Risk Passport until devnet evidence and foundation review PASS.
