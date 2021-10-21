import os, sys

filepath = "new_words.txt"
filedest = "README.md"


def file_ex(file):
    """If file exists, you can divide each row to words in cells."""
    if not os.path.isfile(file):
        print(f"File path {filepath} does not exist. Exiting...")
        sys.exit()


def split_file_strings(header=True, sep=" "):
    file_ex(filepath)
    with open(filedest, "w") as dest:
        with open(filepath, "r") as f:
            for _line in f:
                _line = _line.strip().split(sep)
                res = ""
                i = map(lambda word: f"| {word.ljust(19)}|", _line)
                try:
                    pos = next(i)
                except:
                    break
                while True:
                    try:
                        _pos = next(i)
                        if len(_line) < 3:
                            res += pos + "".ljust(20)
                        else:
                            pos = pos[:-1]
                            res += pos
                        pos = _pos
                    except StopIteration:
                        res += pos
                        break
                dest.write(res + "\n")
                print(res)
                if header:
                    h = ""
                    ver = lambda x: "|" if x == "|" else "-"
                    for ch in res:
                        h += ver(ch)
                    print(h)
                    dest.write(h + "\n")
                    header = False


if __name__ == "__main__":
    split_file_strings()
