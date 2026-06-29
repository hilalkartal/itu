import struct
import hashlib
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import pad, unpad


# AES-256 
def encrypt_aes256(key: bytes, plaintext: bytes) -> bytes:
    """
    Encrypt plaintext with AES-256-CBC.
    A fresh 16-byte IV is generated each call and prepended to the output.
    Returns: IV (16 bytes) || ciphertext
    """
    assert len(key) == 32, "AES-256 requires a 32-byte key"
    iv = get_random_bytes(16)
    cipher = AES.new(key, AES.MODE_CBC, iv)
    ciphertext = cipher.encrypt(pad(plaintext, AES.block_size))
    return iv + ciphertext


def decrypt_aes256(key: bytes, data: bytes) -> bytes:
    """
    Decrypt AES-256-CBC data.
    Expects input format: IV (16 bytes) || ciphertext
    """
    assert len(key) == 32, "AES-256 requires a 32-byte key"
    iv, ciphertext = data[:16], data[16:]
    cipher = AES.new(key, AES.MODE_CBC, iv)
    return unpad(cipher.decrypt(ciphertext), AES.block_size)


#  SHA-256 
def sha256_hash(data: bytes) -> bytes:
    """Return the 32-byte SHA-256 digest of data."""
    return hashlib.sha256(data).digest()


# Socket helpers (length-prefixed framing)
def send_msg(sock, data: bytes) -> None:
    """
    Send a binary message over a TCP socket.
    Frame format: 4-byte big-endian length prefix || payload
    """
    length_prefix = struct.pack('>I', len(data))
    sock.sendall(length_prefix + data)


def recv_msg(sock) -> bytes:
    """
    Receive a length-prefixed binary message from a TCP socket.
    Blocks until the full message is received.
    """
    raw_len = _recv_exact(sock, 4)
    msg_len = struct.unpack('>I', raw_len)[0]
    return _recv_exact(sock, msg_len)


def _recv_exact(sock, n: int) -> bytes:
    """Read exactly n bytes from the socket, handling partial reads."""
    buf = b''
    while len(buf) < n:
        chunk = sock.recv(n - len(buf))
        if not chunk:
            raise ConnectionError("Socket closed before all bytes were received")
        buf += chunk
    return buf
