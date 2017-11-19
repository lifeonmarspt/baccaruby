require "pry"

class Card
  attr_reader :name, :suit, :value

  def initialize(name:,suit:,value:)
    @name = name
    @suit = suit
    @value = value
  end

  def to_s
    "#{name} of #{suit}"
  end
end

class Deck
  attr_reader :cards

  CARD_SUITS = ["Spades", "Clubs", "Hearts", "Diamonds"]
  CARD_NAMES = ["Ace", *(2..10), "Jack", "Queen", "King"].map(&:to_s)

  def initialize(card_values)
    @cards = CARD_SUITS.flat_map do |suit|
      CARD_NAMES.map(&:to_s).map do |name|
        Card.new(name: name, value: card_values[name], suit: suit)
      end
    end
  end
end

class Player
  attr_reader :name, :cards

  def initialize(name:)
    @name = name
    @cards = []
  end

  def get_card(card)
    @cards << card
  end

  def hand_value
    BaccaratRules.hand_value(cards.map(&:value))
  end
end

class BaccaratRules
  CARD_VALUES = {
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 0,
    "Jack" => 0,
    "Queen" => 0,
    "King" => 0,
    "Ace" => 1,
  }

  def self.hand_value(values)
    values.sum % 10
  end

  def self.player_needs_extra_card?(player_hand_value)
    player_hand_value <= 5
  end

  def self.dealer_needs_extra_card?(dealer_hand_value, player_extra_card_value)
    case dealer_hand_value
    when 0..2
      true
    when 3
      [nil,0,1,2,3,4,5,6,7,9].include?(player_extra_card_value)
    when 4
      [nil,2,3,4,5,6,7].include?(player_extra_card_value)
    when 5
      [nil,4,5,6,7].include?(player_extra_card_value)
    when 6
      [6,7].include?(player_extra_card_value)
    else
      false
    end
  end
end

class Baccarat
  def initialize(pile)
    @pile = pile
    @dealer = Player.new(name: "Dealer")
    @player = Player.new(name: "Santos")
  end

  def add_player(player)
    @players << player
  end

  def play
    2.times{ deal_card_to(@player) }

    2.times{ deal_card_to(@dealer) }

    deal_card_to(@player) if player_needs_extra_card?

    deal_card_to(@dealer) if dealer_needs_extra_card?
  end

  def print
    # initial dealings
    [@player, @dealer].each do |player|
      puts "#{player.name} gets #{player.cards[0]} and #{player.cards[1]}"
    end

    # count points
    [@player, @dealer].each do |player|
      puts "#{player.name} has #{BaccaratRules.hand_value(player.cards[0..1].map(&:value))} points"
    end

    # potential new dealings
    [@player, @dealer].each do |player|
      puts "#{player.name} gets #{player.cards[2]}" if player.cards[2]
    end

    # potential new count points
    [@player, @dealer].each do |player|
      puts "#{player.name} has now #{BaccaratRules.hand_value(player.cards.map(&:value))} points" if player.cards[2]
    end

    # determine winner
    if winner
      puts "#{winner.name} wins!"
    else
      puts "Game is a tie."
    end
  end

  def draw_card
    @pile.pop
  end

  def deal_card_to(player)
    card = draw_card
    player.get_card(card)
  end

  def player_needs_extra_card?
    BaccaratRules.player_needs_extra_card?(@player.hand_value)
  end

  def dealer_needs_extra_card?
    BaccaratRules.dealer_needs_extra_card?(@dealer.hand_value, @player.hand_value)
  end

  def winner
    if @player.hand_value > @dealer.hand_value
      @player
    elsif @player.hand_value < @dealer.hand_value
      @dealer
    else
      nil
    end
  end
end
