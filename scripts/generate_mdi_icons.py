import json
import urllib.request
import sys
from pathlib import Path


META_URL = (
    "https://raw.githubusercontent.com/"
    "Templarian/MaterialDesign/master/meta.json"
)


def to_qml_name(name):
    parts = name.split("-")

    return parts[0] + "".join(
        part.capitalize()
        for part in parts[1:]
    )


def parse_codepoint(value):
    if isinstance(value, int):
        return value

    value = str(value).strip()

    if value.startswith("U+"):
        value = value[2:]

    if value.startswith("0x"):
        value = value[2:]

    return int(value, 16)


def main():
    output = Path(
        sys.argv[1]
        if len(sys.argv) > 1
        else "Icons.qml"
    )

    print("Pobieranie meta.json...")

    with urllib.request.urlopen(META_URL) as response:
        metadata = json.loads(response.read())

    if not isinstance(metadata, list):
        raise RuntimeError(
            f"Nieoczekiwany format meta.json: "
            f"{type(metadata).__name__}"
        )

    print(f"Znaleziono {len(metadata)} wpisów.")

    icons = []

    for item in metadata:

        if not isinstance(item, dict):
            continue

        name = item.get("name")
        codepoint = item.get("codepoint")

        if not name or codepoint is None:
            continue

        try:
            codepoint = parse_codepoint(codepoint)
        except (ValueError, TypeError):
            print(
                f"Pominięto {name}: "
                f"nieprawidłowy codepoint {codepoint}"
            )
            continue

        icons.append(
            (
                to_qml_name(name),
                chr(codepoint)
            )
        )

    icons.sort(
        key=lambda x: x[0].lower()
    )

    if not icons:
        raise RuntimeError(
            "Nie znaleziono żadnych ikon z codepoint."
        )

    output.parent.mkdir(
        parents=True,
        exist_ok=True
    )

    with output.open(
        "w",
        encoding="utf-8",
        newline="\n"
    ) as f:

        f.write("pragma Singleton\n")
        f.write("import QtQuick\n\n")
        f.write("QtObject {\n")

        for name, character in icons:
            f.write(
                f'    readonly property string '
                f'{name}: "{character}"\n'
            )

        f.write("}\n")

    print(
        f"Wygenerowano {len(icons)} ikon: "
        f"{output}"
    )


if __name__ == "__main__":
    main()