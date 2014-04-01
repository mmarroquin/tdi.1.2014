class ECommercesController < ApplicationController
  before_action :set_e_commerce, only: [:show, :edit, :update, :destroy]

  # GET /e_commerces
  # GET /e_commerces.json
  def index
    @e_commerces = ECommerce.all
  end

  # GET /e_commerces/1
  # GET /e_commerces/1.json
  def show
  end

  # GET /e_commerces/new
  def new
    @e_commerce = ECommerce.new
  end

  # GET /e_commerces/1/edit
  def edit
  end

  # POST /e_commerces
  # POST /e_commerces.json
  def create
    @e_commerce = ECommerce.new(e_commerce_params)

    respond_to do |format|
      if @e_commerce.save
        format.html { redirect_to @e_commerce, notice: 'E commerce was successfully created.' }
        format.json { render action: 'show', status: :created, location: @e_commerce }
      else
        format.html { render action: 'new' }
        format.json { render json: @e_commerce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /e_commerces/1
  # PATCH/PUT /e_commerces/1.json
  def update
    respond_to do |format|
      if @e_commerce.update(e_commerce_params)
        format.html { redirect_to @e_commerce, notice: 'E commerce was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @e_commerce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /e_commerces/1
  # DELETE /e_commerces/1.json
  def destroy
    @e_commerce.destroy
    respond_to do |format|
      format.html { redirect_to e_commerces_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_e_commerce
      @e_commerce = ECommerce.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def e_commerce_params
      params[:e_commerce]
    end
end
