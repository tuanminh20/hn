require "nokogiri"
require "open-uri"
require "uri"

module HackerNews
  class EntryParser
    def homepage
      parse_entries site_name
    end

    def best
      parse_entries "#{site_name}best"
    end

    def newest
      parse_entries "#{site_name}newest"
    end

    private

    def site_name
      'https://news.ycombinator.com/'
    end

    def parse_entries(url)
      # doc = Nokogiri::HTML(open('spec/fixtures/home.html'))
      doc = Nokogiri::HTML(open(url), nil, 'utf-8')
      tbody = doc.at_css('td.title').parent.parent
      trs = tbody.css('tr').to_a

      10.times.map do |i|
        parse_entry(trs, i)
      end.compact
    end

    private

    def parse_entry(trs, i)
      Entry.new do |entry|
        entry.link = trs[i*3].at_css('td.title a')['href']
        entry.link = URI.join(site_name, entry.link).to_s

        entry_doc = Nokogiri::HTML(open(entry.link), nil, 'utf-8')
        entry.image = entry_doc.at_css("meta[property='og:image']").attributes["content"].value rescue 'https://pbs.twimg.com/profile_images/378800000011494576/9c90acb704cbf9eef6135009c9bb5657_400x400.png'                                                                                                                                                                                                                                     
        
        entry.title = trs[i*3].at_css('td.title a').text

        entry.site = trs[i*3].at_css('td.title span.comhead').text.match(/\((.+)\)/)[1] rescue ''
        entry.points = trs[i*3+1].at_css('td.subtext span').text.to_i rescue -1
        entry.username = trs[i*3+1].at_css('td.subtext a').text rescue ''
        entry.time_string = trs[i*3+1].at_css('td.subtext span.age a').text rescue ''
        entry.num_comments = trs[i*3+1].css('td.subtext a')[1].text.to_i rescue -1

        begin
          entry.id = trs[i*3+1].css('td.subtext a')[1]['href'].match(/\d+/)[0].to_i
        rescue
          entry.id = entry.link.match(/^https:\/\/news\.ycombinator\.com\/item\?id=(\d+)$/)[1].to_i
        end
      end
    rescue
      # do nothing
    end
  end
end
