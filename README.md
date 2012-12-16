# search book using ISBN

## description

* Using sqlite3
* Using jonk

## init

1. edit config/setting.json to your data.
```
# config/setting.json
    "isbn": {
        "key": "your-key",
        "secret": "your-secret",
        "associate_tag": "your-associate_tag"
    },
    "ma": {
        "appid": "your-appid"
    }
```
1. initalieze db
```
% sqlite3 db/queue.db < sql/queue.sql
% sqlite3 db/book.db < sql/book.sql
```

## usage

* input
```
# console
% perl script/jonk-client.pl
```
* worker
```
# another console
% perl script/jonk-worker.pl
```
