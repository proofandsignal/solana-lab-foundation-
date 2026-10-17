# Persistent Devnet Keys — Operator Step

This step happens **locally in WSL**, never in GitHub Actions and never in chat.

The repository now contains:

```bash
bash scripts/provision-devnet-keys.sh
```

The script:

- creates a dedicated Devnet deployer keypair;
- creates a persistent Lab Core program keypair;
- creates a persistent Attestation Engine program keypair;
- uses Solana keygen silent mode so recovery phrases are not printed;
- refuses to overwrite existing identities;
- stores secrets only in the gitignored `.devnet-keys/` directory;
- prints/writes only the three public keys needed for the next reviewed commit.

## Run

From the repository root in WSL:

```bash
git switch foundation/v0.1
git pull
bash scripts/provision-devnet-keys.sh
```

Expected public-only output:

```text
DEVNET_DEPLOYER_PUBKEY=<public address>
LAB_CORE_PROGRAM_ID=<public address>
ATTESTATION_PROGRAM_ID=<public address>
```

## Critical

Do **not**:

- commit `.devnet-keys/`;
- paste any JSON keypair contents into ChatGPT, GitHub issues, PRs or logs;
- rename or regenerate the two program keypairs after their IDs are committed;
- use a Mainnet wallet for this Devnet gate.

Back up the three local JSON files securely. The program keypairs define the persistent program identities.

## Next reviewed change

Only the **public** program IDs are committed into:

- `Anchor.toml [programs.devnet]`;
- `programs/lab-core/src/lib.rs`;
- `programs/attestation-engine/src/lib.rs`.

After that, the manual Devnet workflow preflight must confirm all identities match before deployment.
