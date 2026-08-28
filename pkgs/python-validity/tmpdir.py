import os

# Persisted across reboots. The upstream flake used /tmp, which dropped
# downloaded firmware on every restart.
tmpdir = "/var/lib/python-validity"
try:
    os.makedirs(tmpdir, exist_ok=True)
except OSError:
    pass
