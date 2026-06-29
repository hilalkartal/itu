"""
Usage:
  python bob.py              # normal / encrypted run
  python bob.py --no-encrypt # expect plaintext payload (matches alice --no-encrypt)
"""

import sys
import socket
from crypto_utils import decrypt_aes256, sha256_hash, recv_msg

# main key with KDC 
KB_KDC = bytes.fromhex(
    "a0b1c2d3e4f5a6b7c8d9eafbacbddecf00112233445566778899aabbccddeeff"
)

BOB_HOST, BOB_PORT = "127.0.0.1", 9001

HASH_SIZE = 32

def main():
    no_encrypt = "--no-encrypt" in sys.argv

    if no_encrypt:
        print("[Bob] *** BASELINE MODE: expecting plaintext payload ***\n")

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((BOB_HOST, BOB_PORT))
    server.listen(1)
    print(f"[Bob] Listening on {BOB_HOST}:{BOB_PORT} ...")
    print("[Bob] Waiting for Alice...\n")

    conn, addr = server.accept()
    print(f"[Bob] Connection accepted from {addr}")

    #step 1: Receive and decrypt the ticket 
    ticket_enc = recv_msg(conn)
    print(f"[Bob] Received ticket E(KB-KDC, Ks||IDA) (hex):\n      {ticket_enc.hex()}")

    ticket = decrypt_aes256(KB_KDC, ticket_enc)
    print(f"[Bob] Decrypted ticket (hex):\n      {ticket.hex()}")

    Ks  = ticket[:32]
    IDA = ticket[32:].decode()
    print(f"\n[Bob] Extracted session key Ks (hex):\n      {Ks.hex()}")
    print(f"[Bob] Extracted IDA : '{IDA}'")

    #  Step 2: Receive the message from Alice 
    enc_msg = recv_msg(conn)
    print(f"\n[Bob] Received payload (hex):\n      {enc_msg.hex()}")

    if no_encrypt:
        payload = enc_msg
        print("[Bob] Interpreting as PLAINTEXT (no decryption applied).")
    else:
        payload = decrypt_aes256(Ks, enc_msg)
        print(f"[Bob] Decrypted payload M || H(M) (hex):\n      {payload.hex()}")

    # Step 3: Split M and H(M) 
    H_M_received = payload[-HASH_SIZE:]
    M             = payload[:-HASH_SIZE]

    print(f"\n[Bob] Message M           : {M.decode(errors='replace')}")
    print(f"[Bob] Received  H(M) (hex): {H_M_received.hex()}")

    #  Step 4: Verify integrity
    H_M_computed = sha256_hash(M)
    print(f"[Bob] Recomputed H(M) (hex): {H_M_computed.hex()}")

    print()
    if H_M_received == H_M_computed:
        print("[Bob] ✓  Integrity Verified! Message is authentic and untampered.")
    else:
        print("[Bob] ✗  Verification Failed! H(M) mismatch — message may be tampered.")

    print("\n[Bob] Done.\n")
    conn.close()
    server.close()


if __name__ == "__main__":
    main()
