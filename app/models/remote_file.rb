class RemoteFile < ActiveRecord::Base
  belongs_to :site

  def download
    require 'net/http'
    require 'uri'
    url      = self.url

    url_base = url.split('/')[2]
    url_path = '/'+url.split('/')[3..-1].join('/')
    self.downloaded = 0

    Net::HTTP.start(url_base) do |http|
      response = http.request_head(URI.escape(url_path))
      #ProgressBar #format_arguments=[:title, :percentage, :bar, :stat_for_file_transfer]
      self.size = response['content-length'].to_i
      self.save!
      File.open("test.file", 'w') { |f|
        http.get(URI.escape(url_path)) do |str|
          f.write str
          self.downloaded += str.length
          self.save!
        end
      }
    end
    pbar.finish
    puts "Done."
  end
end
