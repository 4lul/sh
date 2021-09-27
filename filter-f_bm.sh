read -p "Select file: " f_bookmarks
sed '1,/Other Bookmarks/ d' "$f_bookmarks" | grep -o "<DT.*A>" > bm.html
