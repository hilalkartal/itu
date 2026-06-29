"""

  python alice.py              # normal run
  python alice.py --flip-bit   # flip 1 bit in H(M) to trigger Bob's integrity failure
  python alice.py --no-encrypt # send M in plaintext (for Wireshark baseline screenshot)
"""

import sys
import socket
from crypto_utils import encrypt_aes256, decrypt_aes256, sha256_hash, send_msg, recv_msg

# Pre-shared main key with KDC 
KA_KDC = bytes.fromhex(
    "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"
)

IDA = "Alice"
IDB = "Bob"

M = b"150210087 Network Sec."

KDC_HOST, KDC_PORT = "127.0.0.1", 9000
BOB_HOST, BOB_PORT = "127.0.0.1", 9001


def main():
    flip_bit   = "--flip-bit"   in sys.argv
    no_encrypt = "--no-encrypt" in sys.argv

    if flip_bit:
        print("[Alice] *** INTEGRITY TEST MODE: will flip 1 bit in H(M) ***\n")
    if no_encrypt:
        print("[Alice] *** BASELINE MODE: sending plaintext (no encryption) ***\n")

    # ── step 1: Request session key from KDC ─────────────────────────────────
    print(f"[Alice] Connecting to KDC at {KDC_HOST}:{KDC_PORT} ...")
    kdc_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    kdc_sock.connect((KDC_HOST, KDC_PORT))

    request = f"{IDA},{IDB}".encode()
    send_msg(kdc_sock, request)
    print(f"[Alice] Sent request to KDC : IDA='{IDA}'  IDB='{IDB}'")

    # step 2: Receive E(KA-KDC, Ks) and the ticket E(KB-KDC, Ks || IDA) 
    enc_ks_from_kdc   = recv_msg(kdc_sock)
    ticket_for_bob    = recv_msg(kdc_sock)
    kdc_sock.close()

    print(f"\n[Alice] Received E(KA-KDC, Ks) (hex):\n        {enc_ks_from_kdc.hex()}")
    print(f"[Alice] Received ticket E(KB-KDC, Ks||IDA) (hex):\n        {ticket_for_bob.hex()}")

    # step 3: Decrypt E(KA-KDC, Ks) to recover Ks
    Ks = decrypt_aes256(KA_KDC, enc_ks_from_kdc)
    print(f"\n[Alice] Decrypted session key Ks (hex):\n        {Ks.hex()}")


    # step 4: Connect to Bob
    print(f"\n[Alice] Connecting to Bob at {BOB_HOST}:{BOB_PORT} ...")
    bob_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    bob_sock.connect((BOB_HOST, BOB_PORT))

    # step 5:Forward the ticket (Alice cannot decrypt this)
    send_msg(bob_sock, ticket_for_bob)
    print("[Alice] Forwarded ticket E(KB-KDC, Ks||IDA) to Bob.")

   
    # step 5:Send encrypted message
    print(f"\n[Alice] Plaintext message M : {M}")

    H_M = sha256_hash(M)
    print(f"[Alice] H(M) SHA-256 (hex)  : {H_M.hex()}")

    if flip_bit:
        # Flip the least-significant bit of the first byte of H(M)
        H_M_send = bytes([H_M[0] ^ 0x01]) + H_M[1:]
        print(f"[Alice] *** Flipped bit in H(M) (hex): {H_M_send.hex()} ***")
    else:
        H_M_send = H_M

    payload = M + H_M_send
    print(f"\n[Alice] Payload M || H(M) (hex):\n        {payload.hex()}")

    if no_encrypt:
        # Baseline: send raw plaintext
        send_msg(bob_sock, payload)
        print("[Alice] Sent PLAINTEXT payload to Bob (no encryption).")
    else:
        enc_msg = encrypt_aes256(Ks, payload)
        print(f"[Alice] E(Ks, M||H(M)) (hex):\n        {enc_msg.hex()}")
        send_msg(bob_sock, enc_msg)
        print("[Alice] Sent encrypted payload to Bob.")

    bob_sock.close()
    print("\n[Alice] Done.\n")


if __name__ == "__main__":
    main()
