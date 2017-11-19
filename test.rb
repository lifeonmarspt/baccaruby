require_relative "baccarat"
require "test/unit"

def make_card(value)
  Card.new(name: value.to_s, suit: nil)
end

def make_deck(values)
  values.map do |value|
    make_card(value)
  end
end

class BaccaratRulesTest < Test::Unit::TestCase
  def test_hand_value
    assert_equal(0, BaccaratRules.hand_value(make_deck([6, 4])))
    assert_equal(5, BaccaratRules.hand_value(make_deck([4, "Ace"])))
    assert_equal(6, BaccaratRules.hand_value(make_deck([6, "Queen"])))
    assert_equal(1, BaccaratRules.hand_value(make_deck([6, 4, "Queen", "Ace"])))
  end

  def test_player_needs_extra_card?
    assert_true(BaccaratRules.player_needs_extra_card?(make_deck([2, 2])))
    assert_true(BaccaratRules.player_needs_extra_card?(make_deck([2, 3])))
    assert_false(BaccaratRules.player_needs_extra_card?(make_deck([3, 3])))
  end

  def test_dealer_needs_extra_card?
    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck([5,5]), make_deck([])))
    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck([5,5]), make_deck([7])))
    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck(["Ace","Ace"]), make_deck([7])))

    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck(["Ace", 2]), make_deck(["Ace", 2])))
    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck(["Ace", 2]), make_deck(["Ace", 2])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck(["Ace", 2]), make_deck(["Ace", 2, 8])))

    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 2]), make_deck([3, 4])))
    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 2]), make_deck([2, 2, 2])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 2]), make_deck([2, 2, 8])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 2]), make_deck([2, 2, "Ace"])))

    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 3]), make_deck([2, 4])))
    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 3]), make_deck([2, 2, 4])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 3]), make_deck([2, 2, 8])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([2, 3]), make_deck([2, 2, "Ace"])))

    assert_true(BaccaratRules.dealer_needs_extra_card?(make_deck([3, 3]), make_deck([2, 2, 6])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([3, 3]), make_deck([2, 4])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([3, 3]), make_deck([2, 2, 1])))

    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([4, 3]), make_deck([2, 5])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([4, 3]), make_deck([2, 2, 5])))
    assert_false(BaccaratRules.dealer_needs_extra_card?(make_deck([4, 4]), make_deck([3, 6])))
  end
end

class BaccaratTest < Test::Unit::TestCase
  def test_play
    n_decks = 6

    baccarat = Baccarat.new(make_deck([10, 10, 10, 10, 10, 10]).reverse)
    baccarat.play
    assert_equal(nil, baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([6, 2, 5, 3, 10, 10]).reverse)
    baccarat.play
    assert_equal(nil, baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([6, 2, 7, 10, 10, 10]).reverse)
    baccarat.play
    assert_equal("Santos", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([6, 2, 7, 2, 10, 10]).reverse)
    baccarat.play
    assert_equal("Dealer", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([10, 10, 7, 2, 9, 10]).reverse)
    baccarat.play
    assert_equal(nil, baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck(["Ace", 10, 7, "Ace", 8, 10]).reverse)
    baccarat.play
    assert_equal("Santos", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck(["Ace", 10, 10, "Ace", 8, 2]).reverse)
    baccarat.play
    assert_equal("Santos", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck(["Ace", 10, 10, 6, 6, 2]).reverse)
    baccarat.play
    assert_equal("Dealer", baccarat.winner&.name)
  end
end
