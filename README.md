# search a book using ISBN

## description

* Using sqlite3
* Using jonk

## init

1. edit config/setting.json to your data.
<pre><code># config/setting.json
    "isbn": {
        "key": "your-key",
        "secret": "your-secret",
        "associate_tag": "your-associate_tag"
    },
    "ma": {
        "appid": "your-appid"
    }
</code></pre>
1. initalieze db
<pre><code>% sqlite3 db/queue.db < sql/queue.sql
% sqlite3 db/book.db < sql/book.sql
</code></pre>

## usage

* input
<pre><code># console
% perl script/jonk-client.pl
</code></pre>
* worker
<pre><code># another console
% perl script/jonk-worker.pl
</code></pre>
