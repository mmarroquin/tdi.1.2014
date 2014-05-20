class SftpsController < ApplicationController
  before_action :set_sftp, only: [:show, :edit, :update, :destroy]

  # GET /sftps
  # GET /sftps.json
  def index
    @sftps = Sftp.all
    @chld = Sftp.csv
  end

  # GET /sftps/1
  # GET /sftps/1.json
  def show
  end

  # GET /sftps/new
  def new
    @sftp = Sftp.new
  end

  # GET /sftps/1/edit
  def edit
  end

  # POST /sftps
  # POST /sftps.json
  def create
    @sftp = Sftp.new(sftp_params)

    respond_to do |format|
      if @sftp.save
        format.html { redirect_to @sftp, notice: 'Sftp was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sftp }
      else
        format.html { render action: 'new' }
        format.json { render json: @sftp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sftps/1
  # PATCH/PUT /sftps/1.json
  def update
    respond_to do |format|
      if @sftp.update(sftp_params)
        format.html { redirect_to @sftp, notice: 'Sftp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sftp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sftps/1
  # DELETE /sftps/1.json
  def destroy
    @sftp.destroy
    respond_to do |format|
      format.html { redirect_to sftps_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sftp
      @sftp = Sftp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sftp_params
      params[:sftp]
    end
end
