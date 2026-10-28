import lzma
import shutil

# Decompress source.xz into destination_file
with lzma.open("151e1995986dd49b41aae9866736caec-ezfact64_3.shuffled-as.sat03-1519 (1).cnf.xz", "rb") as f_in:
    with open("extracted_output.txt", "wb") as f_out:
        shutil.copyfileobj(f_in, f_out)
