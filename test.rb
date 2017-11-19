require_relative "baccarat"
require "test/unit"
require "mocha/test_unit"

class BaccaratRulesTest < Test::Unit::TestCase
  def test_hand_value
    assert_equal(0, BaccaratRules.hand_value([6, 4]))
    assert_equal(5, BaccaratRules.hand_value([4, 1]))
    assert_equal(6, BaccaratRules.hand_value([6, 0]))
    assert_equal(1, BaccaratRules.hand_value([4, 6, 0, 1]))
  end

  def test_player_needs_extra_card?
    assert_true(BaccaratRules.player_needs_extra_card?(0))
    assert_true(BaccaratRules.player_needs_extra_card?(5))
    assert_false(BaccaratRules.player_needs_extra_card?(6))
  end

  def test_dealer_needs_extra_card?
    assert_true(BaccaratRules.dealer_needs_extra_card?(0, nil))
    assert_true(BaccaratRules.dealer_needs_extra_card?(0, 7))
    assert_true(BaccaratRules.dealer_needs_extra_card?(2, 7))

    assert_true(BaccaratRules.dealer_needs_extra_card?(3, nil))
    assert_true(BaccaratRules.dealer_needs_extra_card?(3, 1))
    assert_false(BaccaratRules.dealer_needs_extra_card?(3, 8))

    assert_true(BaccaratRules.dealer_needs_extra_card?(4, nil))
    assert_true(BaccaratRules.dealer_needs_extra_card?(4, 2))
    assert_false(BaccaratRules.dealer_needs_extra_card?(4, 8))
    assert_false(BaccaratRules.dealer_needs_extra_card?(4, 1))

    assert_true(BaccaratRules.dealer_needs_extra_card?(5, nil))
    assert_true(BaccaratRules.dealer_needs_extra_card?(5, 4))
    assert_false(BaccaratRules.dealer_needs_extra_card?(5, 8))
    assert_false(BaccaratRules.dealer_needs_extra_card?(5, 1))

    assert_true(BaccaratRules.dealer_needs_extra_card?(6, 6))
    assert_false(BaccaratRules.dealer_needs_extra_card?(6, nil))
    assert_false(BaccaratRules.dealer_needs_extra_card?(6, 1))

    assert_false(BaccaratRules.dealer_needs_extra_card?(7, nil))
    assert_false(BaccaratRules.dealer_needs_extra_card?(7, 6))
    assert_false(BaccaratRules.dealer_needs_extra_card?(8, nil))
  end
end

class BaccaratTest < Test::Unit::TestCase
  def test_play
    n_decks = 6

    baccarat = Baccarat.new(make_deck([0, 0, 0, 0, 0, 0]))
    baccarat.play
    assert_equal(nil, baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([6, 2, 5, 3, 0, 0]))
    baccarat.play
    assert_equal(nil, baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([6, 2, 7, 0, 0, 0]))
    baccarat.play
    assert_equal("Santos", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([6, 2, 7, 2, 0, 0]))
    baccarat.play
    assert_equal("Dealer", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([0, 0, 7, 2, 9, 0]))
    baccarat.play
    assert_equal(nil, baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([1, 0, 7, 1, 8, 0]))
    baccarat.play
    assert_equal("Santos", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([1, 0, 0, 1, 8, 2]))
    baccarat.play
    assert_equal("Santos", baccarat.winner&.name)

    baccarat = Baccarat.new(make_deck([1, 0, 0, 6, 6, 2]))
    baccarat.play
    assert_equal("Dealer", baccarat.winner&.name)
  end

  def make_deck(values)
    values.map do |value|
      make_card(value)
    end.reverse
  end

  def make_card(value)
    Card.new(name: nil, suit: nil, value: value)
  end
end
