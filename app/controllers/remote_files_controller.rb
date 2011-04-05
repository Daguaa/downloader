class RemoteFilesController < ApplicationController
  require 'uri'
  # GET /remote_files
  # GET /remote_files.xml
  def index
    @remote_files = RemoteFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @remote_files }
    end
  end

  # GET /remote_files/1
  # GET /remote_files/1.xml
  def show
    @remote_file = RemoteFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @remote_file }
    end
  end

  # GET /remote_files/new
  # GET /remote_files/new.xml
  def new
    @remote_file = RemoteFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @remote_file }
    end
  end

  # GET /remote_files/1/edit
  def edit
    @remote_file = RemoteFile.find(params[:id])
  end

  # POST /remote_files
  # POST /remote_files.xml
  def create
    @remote_file = RemoteFile.new(params[:remote_file])
    myUri = URI.parse( 'http://www.mglenn.com/directory' )
    s = Site.find_or_create_by_url(myUri.host)
    @remote_file.site=s
    @remote_file.download


    respond_to do |format|
      if @remote_file.save
        format.html { redirect_to(@remote_file, :notice => 'Remote file was successfully created.') }
        format.xml  { render :xml => @remote_file, :status => :created, :location => @remote_file }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @remote_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /remote_files/1
  # PUT /remote_files/1.xml
  def update
    @remote_file = RemoteFile.find(params[:id])

    respond_to do |format|
      if @remote_file.update_attributes(params[:remote_file])
        format.html { redirect_to(@remote_file, :notice => 'Remote file was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @remote_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /remote_files/1
  # DELETE /remote_files/1.xml
  def destroy
    @remote_file = RemoteFile.find(params[:id])
    @remote_file.destroy

    respond_to do |format|
      format.html { redirect_to(remote_files_url) }
      format.xml  { head :ok }
    end
  end
end
