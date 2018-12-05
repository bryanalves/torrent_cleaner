# torrent\_cleaner

This is a tool to remove torrents in rtorrent that meet a certain ratio threshold for certain trackers.

```
bundle install
bundle exec ruby cli.rb --rtorrent-url http://localhost:80 --ratio 1 --tracker publictracker.com
```

Also available as a CRI image:

```
docker build -t torrent_cleaner .
docker run --rm -it --net host torrent_cleaner --rtorrent-url http://pathtortorrent:80 --ratio 1 --tracker publictracker.com
```
