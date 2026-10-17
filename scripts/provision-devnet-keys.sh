#!/usr/bin/env bash
set -euo pipefail

KEY_DIR="${1:-.devnet-keys}"
DEPLOYER="$KEY_DIR/devnet-deployer.json"
CORE="$KEY_DIR/lab_core-keypair.json"
ATTEST="$KEY_DIR/attestation_engine-keypair.json"
PUBLIC="$KEY_DIR/PUBLIC_KEYS.txt"

umask 077
mkdir -p "$KEY_DIR"

for f in "$DEPLOYER" "$CORE" "$ATTEST"; do
  if [ -e "$f" ]; then
    echo "REFUSE: $f already exists. Existing persistent identities will not be overwritten." >&2
    exit 10
  fi
done

command -v solana-keygen >/dev/null 2>&1 || {
  echo "REFUSE: solana-keygen is not installed or not on PATH." >&2
  exit 11
}

# -s / --silent prevents printing recovery seed phrases.
solana-keygen new -o "$DEPLOYER" -s --no-bip39-passphrase
solana-keygen new -o "$CORE" -s --no-bip39-passphrase
solana-keygen new -o "$ATTEST" -s --no-bip39-passphrase

chmod 600 "$DEPLOYER" "$CORE" "$ATTEST"

DEPLOYER_PUB="$(solana-keygen pubkey "$DEPLOYER")"
CORE_PUB="$(solana-keygen pubkey "$CORE")"
ATTEST_PUB="$(solana-keygen pubkey "$ATTEST")"

cat > "$PUBLIC" <<EOF
DEVNET_DEPLOYER_PUBKEY=$DEPLOYER_PUB
LAB_CORE_PROGRAM_ID=$CORE_PUB
ATTESTATION_PROGRAM_ID=$ATTEST_PUB
EOF
chmod 600 "$PUBLIC"

echo
echo "Persistent Devnet identities created locally."
echo "Secret JSON files are under: $KEY_DIR"
echo "They are gitignored. Do NOT upload or paste them anywhere."
echo
cat "$PUBLIC"
echo
echo "Back up the three JSON keypair files securely before deployment."
