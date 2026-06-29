import socket
from Crypto.Random import get_random_bytes
from crypto_utils import encrypt_aes256, send_msg, recv_msg

# ── Pre-shared main keys
#  Alice 
KA_KDC = bytes.fromhex(
    "0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20"
)  

#Bob 
KB_KDC = bytes.fromhex(
    "a0b1c2d3e4f5a6b7c8d9eafbacbddecf00112233445566778899aabbccddeeff"
)   

KDC_HOST = "127.0.0.1"
KDC_PORT = 9000

def main():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((KDC_HOST, KDC_PORT))
    server.listen(1)
    print(f"[KDC] Listening on {KDC_HOST}:{KDC_PORT} ...")
    print("[KDC] Waiting for Alice's request...\n")

    conn, addr = server.accept()
    print(f"[KDC] Connection accepted from {addr}")

    #  Step 1: Receive request from Alice 
    request_bytes = recv_msg(conn)
    request_str   = request_bytes.decode()
    IDA, IDB      = request_str.split(",")
    print(f"[KDC] Received request  : IDA='{IDA}'  IDB='{IDB}'")

    #  Step 2: Generate random session key Ks 
    Ks = get_random_bytes(32)
    print(f"\n[KDC] Generated session key Ks (hex):\n      {Ks.hex()}")

    #  Step 3: Encrypt Ks for Alice using KA-KDC 
    enc_ks_for_alice = encrypt_aes256(KA_KDC, Ks)
    print(f"\n[KDC] E(KA-KDC, Ks) (hex):\n      {enc_ks_for_alice.hex()}")

    #  Step 4: Encrypt (Ks || IDA) for Bob using KB-KDC 
    ticket_plaintext = Ks + IDA.encode()
    enc_ticket_for_bob = encrypt_aes256(KB_KDC, ticket_plaintext)
    print(f"\n[KDC] Ticket plaintext  Ks || IDA (hex):\n      {ticket_plaintext.hex()}")
    print(f"[KDC] E(KB-KDC, Ks || IDA) (hex):\n      {enc_ticket_for_bob.hex()}")

    #  Send both back to Alice 
    send_msg(conn, enc_ks_for_alice)
    send_msg(conn, enc_ticket_for_bob)
    print("\n[KDC] Sent E(KA-KDC, Ks) and E(KB-KDC, Ks||IDA) to Alice.")
    print("[KDC] Done.\n")

    conn.close()
    server.close()


if __name__ == "__main__":
    main()
