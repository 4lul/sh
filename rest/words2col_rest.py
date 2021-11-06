import os, sys
from functools import reduce

filepath = "new_words.txt"


#def make_table(grid):
#    cell_width = 2 + max(
#        reduce(lambda x, y: x + y, [[len(item) for item in row] for row in grid], [])
#    )
#    num_cols = len(grid[0])
#    rst = table_div(num_cols, cell_width, 0)
#    header_flag = 1
#    for row in grid:
#        rst = (
#            rst
#            + "| "
#            + "| ".join([normalize_cell(x, cell_width - 1) for x in row])
#            + "|\n"
#        )
#        rst = rst + table_div(num_cols, cell_width, header_flag)
#        header_flag = 0
#    return rst


def table_div(num_cols, col_width, header_flag):
    if header_flag == 1:
        return num_cols * ("+" + (col_width) * "=") + "+"
    else:
        return num_cols * ("+" + (col_width) * "-") + "+"


def normalize_cell(string, length):
    return string + ((length - len(string)) * " ")


def file_ex(file):
    """If file exists, you can divide each row to words in cells."""
    if not os.path.isfile(file):
        print(f"File path {filepath} does not exist. Exiting...")
        sys.exit()


def str2cell(line):
    res = ""
    iter_w = map(lambda word: f"| {word[:18].ljust(19)}|", line)
    try:
        pos = next(iter_w)
    except:
        return
    while True:
        try:
            _pos = next(iter_w)
            if len(line) < 3:
                res += pos + "".ljust(20)
            else:
                pos = pos[:-1]
                res += pos
            pos = _pos
        except StopIteration:
            res += pos
            break
    return res


def split_file_strings(header=True, sep=" "):
    file_ex(filepath)

    def print_row(line, sep, header):
        cells = str2cell(line.strip().split(sep))
        if header:
            print(table_div(3, 20, 0))
        print(cells)
        print(table_div(3, 20, header))

    with open(filepath, "r") as f:
        print_row(f.readline(), sep, header)
        header = False
        for _line in f:
            print_row(_line, sep, header)


if __name__ == "__main__":

    split_file_strings()
