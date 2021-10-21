import psycopg, words2col


def write2db():
    words2col.file_ex()
    with psycopg.connect("dbname=eng_tr user=postgres") as conn:
        with conn.cursor() as cur:
            with open(words2col.filepath, "r") as f:
                for line in f:
                    line = line.strip().split()
                    cur.execute("INSERT INTO words (en, ru) VALUES (%s, %s)", 
                                (line[0], line[1]))
            conn.commit()
            cur.execute("SELECT * FROM words")
            cur.fetchone()
            for record in cur:
                print(record)


if __name__ == "__main__":
    write2db()
