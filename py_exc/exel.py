from pathlib import Path
import pandas as pd

path = Path("exel/")
min_excel_file_size = 1

df = pd.concat([pd.read_excel(f)
for f in path.glob('*.xls')
    if f.stat().st_size >= min_excel_file_size],
       ignore_index=True)

df.to_excel('final.xlsx')
