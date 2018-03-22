class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index

    if params[:game_search]
      game_search_term = params[:game_search]
      mechanize = Mechanize.new

      # INSTANT GAMING SEARCH
      instant_game_page = mechanize.get('https://www.instant-gaming.com/it/')
      search_input = instant_game_page.forms.first
      search_input['q'] = game_search_term
      instant_game_page = search_input.submit
      results = instant_game_page.at('.search')
      game = results.search('div')[0]

      game_price = game.at('.price')
      game_name = game.at('.name')
      game_platform = game.at('.badge').attr('class')
      game_link = game.at('.cover')["href"]
      game_image = game.at('.picture.mainshadow')["src"]

      puts '0000000000000000000000 INSTANT GAMING RESULT 00000000000000000000000000000000000'
      puts game_price.text.strip
      puts game_name.text.strip
      puts game_link
      puts game_image
      puts game_platform.remove('badge').strip
      puts '00000000000000000000000000 END INSTANT GAMING RESULT 0000000000000000000000000000000'


    #KINGUIN SEARCH
      # kinguin_page = mechanize.get('https://www.kinguin.net')
      # search_input = kinguin_page.forms.first
      # search_input['q'] = game_search_term
      # kinguin_page = search_input.submit
      #
      # results = kinguin_page.at('.cat-v1')
      # offer_details = results.at('#offerDetails')
      #
      # div_game = offer_details.search('div')[0]
      #
      # div_price = div_game.at('.actual-price')
      # div_name = div_game.at('.product-name')
      #
      # puts '0000000000000000000000 KINGUIN RESULT 00000000000000000000000000000000000'
      # puts div_name.text.strip
      # puts div_price.text.strip
      # puts '00000000000000000000000000 END KINGUIN RESULT 0000000000000000000000000000000'

    #G2A SEARCH
      # g2a_page = mechanize.get('https://www.g2a.com/')
      # search_input = g2a_page.forms.first
      # search_input['query'] = game_search_term
      # g2a_page = search_input.submit
      #
      # results = g2a_page.at('.products-grid')
      # div_game = results.search('li')[0]
      #
      # div_price = div_game.at('.Card__price')
      # div_name = div_game.at('.Card__title')
      #
      # puts '0000000000000000000000 G2A RESULT 00000000000000000000000000000000000'
      # puts div_name.text.strip
      # puts div_price.text.strip
      # puts '00000000000000000000000000 END G2A RESULT 0000000000000000000000000000000'

    end

  end



  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:name, :search, :kinguinPrice, :instantGamingPrice, :g2aPrice)
    end
end
