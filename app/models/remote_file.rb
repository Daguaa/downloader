class RemoteFile < ActiveRecord::Base
  belongs_to :site

  def download
    require 'net/http'
    require 'uri'
    require 'UUID'
    url      = self.url

    url_base = url.split('/')[2]
    url_path = '/'+url.split('/')[3..-1].join('/')
    self.downloaded = 0

    Net::HTTP.start(url_base) do |http|
      headReq = Net::HTTP::Head.new(URI.escape(url_path))
      unless self.site.login.nil?
        headReq.basic_auth self.site.login, self.site.password
      end
      response = http.request(headReq)
      #ProgressBar #format_arguments=[:title, :percentage, :bar, :stat_for_file_transfer]
      self.original_name = URI.parse(url).path[%r{[^/]+\z}]
      self.name = UUID.new.generate
      self.size = response['content-length'].to_i
      self.save!
      i =0
      File.open("public/downloads/"+self.name, 'w') { |f|
        getReq = Net::HTTP::Get.new(URI.escape(url_path))
        unless self.site.login.nil?
          getReq.basic_auth self.site.login, self.site.password
        end
        http.request(getReq) do |str|
          f.write str
          self.downloaded += str.length
          if downloaded>i*(size/25)
            i += 1
            self.save
          end
        end
      }
    end
    self.save
  end

  def redownload=(var)
    unless var == "0"
      FileUtils.rm('public/downloads/'+self.name)
      self.downloaded = 0
      self.save!
      self.delay.download
    end
  end

  def redownload
    false
  end
end
