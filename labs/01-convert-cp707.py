from pathlib import Path
import shutil
import subprocess
import sys


def main() -> int:
    repo_root = Path(__file__).resolve().parents[1]
    input_pdf = repo_root / "samples" / "cp707.pdf"
    output_dir = repo_root / "samples"
    generated_md = output_dir / "cp707" / "cp707.md"
    output_md = output_dir / "cp707.md"

    if not input_pdf.exists():
        print(f"Input file not found: {input_pdf}", file=sys.stderr)
        return 1

    command = [
        "uv",
        "run",
        "marker_single",
        str(input_pdf),
        "--output_dir",
        str(output_dir),
    ]
    subprocess.run(command, cwd=repo_root, check=True)

    if not generated_md.exists():
        print(f"Marker output not found: {generated_md}", file=sys.stderr)
        return 1

    shutil.copyfile(generated_md, output_md)
    print(f"Converted {input_pdf} -> {output_md}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
