require 'retort'

class Cleaner
  def initialize(ratio:, tracker: nil, dry_run: true)
    @ratio = ratio
    @tracker = tracker
    @dry_run = dry_run
  end

  def run
    matches = Retort::Torrent.all.select do |torrent|
      torrent.complete == 1 &&
        ratio_sufficient?(torrent) &&
        hosts_match?(torrent)
    end

    matches.each { |torrent| maybe_erase(torrent) }

    nil
  end

  private

  def maybe_erase(torrent)
    if @dry_run
      puts "Would delete #{torrent.torrent_name}"
    else
      puts "Deleting #{torrent.torrent_name}"
      Retort::Torrent.action(:erase, torrent.info_hash)
    end
  end

  def ratio_sufficient?(torrent)
    return true unless @ratio

    up_total = Retort::Service.call('d.get_up_total', torrent.info_hash)

    ratio = up_total / torrent.size_raw.to_f

    ratio >= @ratio
  end

  def hosts_match?(torrent)
    return true unless @tracker
    tracker_hosts = Retort::Service
                    .call('t.multicall', torrent.info_hash, '', 't.get_url=')
                    .flatten
                    .map do |tracker|
                      URI.parse(tracker)
                    end
                    .map(&:host)

    tracker_hosts.include?(@tracker)
  end
end
