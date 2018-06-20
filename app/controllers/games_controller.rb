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
      games = results.search('.item')

      count_elements = 0
      @instant_game_array = []

      games.each do |game|

        game_price = game.at('.price').text.strip
        game_name = game.at('.name').text.strip
        game_platform = game.at('.badge').attr('class').remove('badge').strip
        game_link = game.at('.cover')["href"]
        game_image = game.at('.picture.mainshadow')["src"]

        hash =  {price:game_price,name:game_name,platform:game_platform,link:game_link,image:game_image}
        @instant_game_array << hash

        count_elements = count_elements + 1
      end

      # puts '0000000000000000000000 INSTANT GAMING RESULT 00000000000000000000000000000000000'
      # puts instant_game_array
      # puts '00000000000000000000000000 END INSTANT GAMING RESULT 0000000000000000000000000000000'

    #KINGUIN SEARCH
      kinguin_page = mechanize.get('https://www.kinguin.net')
      search_input = kinguin_page.forms.first
      search_input['q'] = game_search_term
      kinguin_page = search_input.submit

      results = kinguin_page.at('.cat-v1')
      # offer_details = results.at('#offerDetails')

      games = results.search('.category')

      @kinguin_games_array = []

      games.each do |game|

        if game.at('.actual-price')
        game_price = game.at('.actual-price').text.strip
        game_name = game.at('.product-name').text.strip
        else
          next
        end

        game_platform_container = game.at('.properties')
        game_platform = game_platform_container.at('div')['title']

        game_link_container = game.at('.product-name')
        game_link_h4 = game_link_container.at('h4')
        game_link = game_link_h4.at('a')["href"]

        game_image_container = game.at('.main-image')
        game_image_array = game_image_container.search('img')[0]
        game_image = game_image_array['src']

        hash =  {price:game_price,name:game_name,platform:game_platform.remove('Platform: '),link:game_link,image:game_image}
        @kinguin_games_array << hash
      end

      # puts '0000000000000000000000 KINGUIN RESULT 00000000000000000000000000000000000'
      # puts kinguin_games_array
      # puts '00000000000000000000000000 END KINGUIN RESULT 0000000000000000000000000000000'

    #G2A SEARCH
      g2a_page = mechanize.get('https://www.g2a.com/')
      search_input = g2a_page.forms.first
      search_input['query'] = game_search_term
      g2a_page = search_input.submit

      results = g2a_page.at('.products-grid')
      games = results.search('li')

      @g2a_games_array = []

      games.each do |game|
        game_price = game.at('.Card__price').text.strip
        game_name = game.at('.Card__title').text.strip

        game_link_container = game.at('.Card__media')
        game_link = 'https://www.g2a.com' + game_link_container.at('a')['href']

        game_image = game.at('.Card__img.Card__img--placeholder')['src']

        hash =  {price:game_price,name:game_name,platform:nil,link:game_link,image:game_image}
        @g2a_games_array << hash

      end

      # puts '0000000000000000000000 G2A RESULT 00000000000000000000000000000000000'
      # puts g2a_games_array
      # puts '00000000000000000000000000 END G2A RESULT 0000000000000000000000000000000'

      # @sites_array = []
      #
      # instant_game_array.each do |instant|
      #   @sites_array << instant
      #   kinguin_games_array.each do |kinguin|
      #     @sites_array << kinguin
      #     g2a_games_array.each do |g2a|
      #       @sites_array << g2a
      #     end
      #   end
      # end

      # puts '0000000000000000000000 G2A RESULT 00000000000000000000000000000000000'
      # puts @sites_array
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
