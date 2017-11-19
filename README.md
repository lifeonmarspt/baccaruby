# Baccaruby

Baccarat implementation in ruby.

```ruby
n_decks = 6
cards = (Deck.new(BaccaratRules::CARD_VALUES).cards * n_decks).shuffle
b = Baccarat.new(cards)
b.play
b.print
```
