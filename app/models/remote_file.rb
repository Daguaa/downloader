class RemoteFile < ActiveRecord::Base

  require 'net/http'
  require 'uri'
  require 'UUID'
  include ActiveRecord::Transitions
  after_create :get_info
  belongs_to :site

  state_machine do
    state :added
    state :started
    state :finished
    state :paused
    state :stopped
    state :invalid

    event :start do
      transitions :to=>:started, :from => [:added, :paused], :guard => :start_download
    end
    event :finish do
      transitions :to => :finished, :from => :started
    end
    event :pause do
      transitions :to => :paused, :from => :started
    end
    event :stop do
      transitions :to => :stopped, :from => [:started, :paused]
    end
    event :invalidate do
      transitions :to => :invalid, :from => :added
    end
  end

  def start_download
    self.delay.download
  end

  def get_info

    url             = self.url

    url_base        = url.split('/')[2]
    url_path        = '/'+url.split('/')[3..-1].join('/')
    self.downloaded = 0
    begin

      Net::HTTP.start(url_base) do |http|
        headReq = Net::HTTP::Head.new(URI.escape(url_path))
        unless self.site.login.nil?
          headReq.basic_auth self.site.login, self.site.password
        end
        response           = http.request(headReq)
        self.original_name = URI.parse(url).path[%r{[^/]+\z}]
        self.name          = UUID.new.generate
        self.size          = response['content-length'].to_i
        self.save!
      end
    rescue Errno::ECONNREFUSED => e
      self.invalidate!
    end
  end

  def download
    url      = self.url

    url_base = url.split('/')[2]
    url_path = '/'+url.split('/')[3..-1].join('/')

    Net::HTTP.start(url_base) do |http|
      i =0
      File.open("public/downloads/"+self.name, 'w') { |f|
        getReq = Net::HTTP::Get.new(URI.escape(url_path))
        unless self.site.login.nil?
          getReq.basic_auth self.site.login, self.site.password
        end
        unless downloaded.nil?
          getReq.range = Range.new(downloaded, size)
        end
        http.request(getReq) do |res|
          if self.state == 'paused'
            self.save!
            return 0
          end
          res.read_body do |str|
            f.write str
            if self.state == "paused"
              self.save!
              return 0
            end
            self.downloaded += str.length
            if downloaded>i*(size/100)
              i += 1
              self.save!
              self.reload
            end
          end
        end

      }
    end
    unless downloaded != size
      self.finish!
    end
    self.save
  end

  def change_state=(new_state)
    if new_state == "Pause"
      self.pause!
    end
    if new_state == "Start"
      self.start!
    end
    if new_state == "Reset"
      FileUtils.rm('public/downloads/'+self.name)
      self.downloaded = 0
      self.save!
      self.start!
    end
  end

  def change_state
    return self.state
  end

end
