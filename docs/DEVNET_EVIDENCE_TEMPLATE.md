# Devnet Evidence — Foundation v0.1

> Fill only from verified devnet transactions and RPC reads. Never include private keys, seed phrases or secret JSON.

## Deployment provenance

- Git commit:
- UTC timestamp:
- RPC endpoint: `https://api.devnet.solana.com`
- Deployer public key:
- Upgrade authority public key:

## Program identities

### Lab Core
- Program ID:
- Deploy transaction/signature:
- Finalized slot:
- Executable: YES / NO
- Loader owner:
- ProgramData address:
- Upgrade authority verified: YES / NO

### Attestation Engine
- Program ID:
- Deploy transaction/signature:
- Finalized slot:
- Executable: YES / NO
- Loader owner:
- ProgramData address:
- Upgrade authority verified: YES / NO

## Core functional evidence

- `initialize` transaction:
- Finalized slot:
- Config PDA:
- Authority readback:
- Version readback:
- Status readback:
- PASS / FAIL:

### Core adversarial checks
- version=0 rejected:
- unauthorized status change rejected:
- expected error/reason verified:
- PASS / FAIL:

## Attestation functional evidence

- Subject public key:
- Evidence hash (public test payload only):
- Create transaction:
- Attestation PDA:
- Created status readback:
- Revoke transaction:
- Revoked status readback:
- Evidence hash unchanged after revoke: YES / NO
- PASS / FAIL:

### Attestation adversarial checks
- schema=0 rejected:
- version=0 rejected:
- zero evidence hash rejected:
- duplicate identical attestation rejected:
- unauthorized revoke rejected:
- expected errors/reasons verified:
- PASS / FAIL:

## Final gate

- Identity PASS:
- Deployment PASS:
- Core PASS:
- Attestation PASS:
- Adversarial PASS:
- Provenance PASS:
- Security checklist reviewed:
- **DEVNET GATE: PASS / FAIL**

## Release decision

Only after independent verification:

`LOCAL PASS → DEVNET PASS → FOUNDATION REVIEW → MERGE PR #1 → FOUNDATION PASS → RISK PASSPORT v0.1 UNLOCKED`
