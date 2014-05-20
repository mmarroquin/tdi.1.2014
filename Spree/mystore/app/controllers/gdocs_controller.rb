class GdocsController < ApplicationController
  before_action :set_gdoc, only: [:show, :edit, :update, :destroy]

  # GET /gdocs
  # GET /gdocs.json
  def index
    @gdocs = Gdoc.all
    @datee = Gdoc.obtain_date
    @rowss = Gdoc.obtain_rows

#    @filas.each do |n|
#      ProductosNuevos.create(:SKU => n[0], :cliente => n[1], :cantidad => n[2], :utilizado => n[3])
#    end
  end

  # GET /gdocs/1
  # GET /gdocs/1.json
  def show
  end

  # GET /gdocs/new
  def new
    @gdoc = Gdoc.new
  end

  # GET /gdocs/1/edit
  def edit
  end

  # POST /gdocs
  # POST /gdocs.json
  def create
    @gdoc = Gdoc.new(gdoc_params)

    respond_to do |format|
      if @gdoc.save
        format.html { redirect_to @gdoc, notice: 'Gdoc was successfully created.' }
        format.json { render action: 'show', status: :created, location: @gdoc }
      else
        format.html { render action: 'new' }
        format.json { render json: @gdoc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gdocs/1
  # PATCH/PUT /gdocs/1.json
  def update
    respond_to do |format|
      if @gdoc.update(gdoc_params)
        format.html { redirect_to @gdoc, notice: 'Gdoc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gdoc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gdocs/1
  # DELETE /gdocs/1.json
  def destroy
    @gdoc.destroy
    respond_to do |format|
      format.html { redirect_to gdocs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gdoc
      @gdoc = Gdoc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gdoc_params
      params[:gdoc]
    end
end
