import hashlib
from collections import defaultdict
from pathlib import Path


def sha256(path, chunk_size=1024 * 1024):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(chunk_size), b""):
            h.update(chunk)
    return h.hexdigest()


def score(path: Path):
    """
    Cuanto mayor el score, más preferible es conservar el archivo
    """
    depth = len(path.parts)
    in_folder = 1 if path.parent != ROOT else 0
    return (in_folder, depth)


files_by_hash = defaultdict(list)

DUP_DIR = Path("duplicates")
DUP_DIR.mkdir(exist_ok=True)

ROOT = Path(".")

print("Calculating hashes... this may take a while 🐢")

for file in ROOT.rglob("*"):
    if not file.is_file():
        continue

    try:
        file_hash = sha256(file)
        files_by_hash[file_hash].append(file)
    except Exception as e:
        print(f"Skipping {file}: {e}")

print("\nRemoving duplicates...\n")

deleted = 0

for file_hash, files in files_by_hash.items():
    if len(files) <= 1:
        continue
    # ordenamos por preferencia (mejor primero)
    files.sort(key=score, reverse=True)

    # conservamos el primero, borramos el resto
    keeper = files[0]
    duplicates = files[1:]

    for dup in duplicates:
        # sustituye dup.unlink() por:
        print(f"Deleting duplicate: {dup}")
        dup.rename(DUP_DIR / dup.name)
        # dup.unlink()
        deleted += 1

print(f"\nDone. Deleted {deleted} duplicate files 🧹")
