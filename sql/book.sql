CREATE VIRTUAL TABLE book USING fts4(
    isbn,
    asin,
    title,
    author,
    manufacturer,
    words
);
