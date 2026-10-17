#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <lab-core-keypair.json> <attestation-keypair.json>" >&2
  exit 2
fi

CORE_KEYPAIR="$1"
ATTEST_KEYPAIR="$2"

RPC_URL="$(solana config get | awk -F': ' '/RPC URL/ {print $2}')"
case "$RPC_URL" in
  *devnet*) ;;
  *)
    echo "REFUSE: Solana RPC is not devnet: $RPC_URL" >&2
    exit 10
    ;;
esac

CORE_ID="$(solana-keygen pubkey "$CORE_KEYPAIR")"
ATTEST_ID="$(solana-keygen pubkey "$ATTEST_KEYPAIR")"

echo "Core persistent program ID: $CORE_ID"
echo "Attestation persistent program ID: $ATTEST_ID"

grep -F "lab_core = \"$CORE_ID\"" Anchor.toml >/dev/null || {
  echo "REFUSE: Anchor.toml devnet lab_core does not match persistent keypair." >&2
  exit 11
}

grep -F "attestation_engine = \"$ATTEST_ID\"" Anchor.toml >/dev/null || {
  echo "REFUSE: Anchor.toml devnet attestation_engine does not match persistent keypair." >&2
  exit 12
}

grep -F "declare_id!(\"$CORE_ID\")" programs/lab-core/src/lib.rs >/dev/null || {
  echo "REFUSE: lab-core declare_id does not match persistent keypair." >&2
  exit 13
}

grep -F "declare_id!(\"$ATTEST_ID\")" programs/attestation-engine/src/lib.rs >/dev/null || {
  echo "REFUSE: attestation-engine declare_id does not match persistent keypair." >&2
  exit 14
}

echo "Devnet identity preflight PASS."
