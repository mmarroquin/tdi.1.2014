class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:sku, :price, :start_date, :final_date)
    end

  def read_csv
    @columns = "SIN ERROR"
    @rows = []
    filename = '/home/administrator/commandsapp/llamarRuby/outputJava.csv'
    file = File.new(filename, 'r')

    file.each_line("\n") do |row|
      columns = row.split(',')
      begin
        fi = columns[3].split('/')
        fechaI = fi[1]+'/'+fi[0]+'/'+fi[2]
        feIn = Time.parse(fechaI)
        ff = columns[4].split('/')
        fechaI = ff[1]+'/'+ff[0]+'/'+ff[2]
        feFi = Time.parse(fechaI)
        Product.create(:sku=>columns[1], :precio=>columns[2], :fecha_inico=>feIn, :fecha_fin=>feFi)
      rescue Exception => e
        @rows << columns
      end     
    end
end
