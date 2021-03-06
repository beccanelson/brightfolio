class ElementsController < ApplicationController
  before_action :set_element, only: [:show, :edit, :update, :destroy]

  before_action :authorize, except: :index


  def index
    @folio = Folio.find(params[:folio_id])
    @element = Element.new
    @elements = @folio.elements.order("created_at DESC")
    if params[:token] != nil
      check_for_token
      render "public_index"
    elsif params[:mood_board]
      authorize
      render "mood_board"
    else
      authorize
    end
  end

  # def new
  #   @element = Element.new
  # end

  def edit
    @element = Element.find_or_initialize_by(id: params[:id])
  end

  def create
    @element = Element.new(element_params)

    if @element.element_link.empty?
      @element.element_link
    else
      @element.format_link
    end

    @element.font = params[:font]
    @element.color = params[:color]
    @element.width = params[:width]
    @folio = Folio.find(params[:folio_id])
    @elements = @folio.elements.order("created_at DESC")
    respond_to do |format|
      if @element.save
        format.html { redirect_to folio_elements_path, notice: 'Element was successfully created.' }
        format.json { render :show, status: :created, location: @folio }
      else
        format.html { render :index  }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
    end


  end

  def update
    @element.font = params[:font]
    @element.color = params[:color]
    @element.width = params[:width]
    @folio = Folio.find(params[:folio_id])
    @elements = @folio.elements.order("created_at DESC")
    respond_to do |format|
      if @element.update(element_params)
        @folio = Folio.find(params[:folio_id])
        format.html { redirect_to folio_elements_path, notice: 'Element was successfully updated.' }
        format.json { render :show, status: :ok, location: @folio }
      else
        format.html { render :index }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @element.destroy
    respond_to do |format|
      # format.html { redirect_to elements_url, notice: 'Element was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def check_for_token
      folio = Folio.find(params[:folio_id])
      unless folio.token == params[:token]
        redirect_to login_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_element
      @element = Element.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def element_params

      params.require(:element).permit(:folio_id, :title, :description, :citation, :image, :document, :image_content_type, :document_content_type, :audio, :audio_content_type, :element_link, :font)
    end
end
