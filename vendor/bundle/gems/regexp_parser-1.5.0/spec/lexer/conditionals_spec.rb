require 'spec_helper'

RSpec.describe('Conditional lexing') do
  # Basic lexer output and nesting tests
  tests = {
    '(?<A>a)(?(<A>)b|c)'  => [3, :conditional, :open,       '(?',     7,  9, 0, 0, 0],
    '(?<B>a)(?(<B>)b|c)'  => [4, :conditional, :condition,  '(<B>)',  9, 14, 0, 0, 1],
    '(?<C>a)(?(<C>)b|c)'  => [6, :conditional, :separator,  '|',     15, 16, 0, 0, 1],
    '(?<D>a)(?(<D>)b|c)'  => [8, :conditional, :close,      ')',     17, 18, 0, 0, 0],
  }

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te, level, set_level, conditional_level)), count|
    specify("lexer_#{type}_#{token}_#{count}") do
      tokens = RL.lex(pattern)
      struct = tokens.at(index)

      expect(struct.type).to eq type
      expect(struct.token).to eq token
      expect(struct.text).to eq text
      expect(struct.ts).to eq ts
      expect(struct.te).to eq te
      expect(struct.level).to eq level
      expect(struct.set_level).to eq set_level
      expect(struct.conditional_level).to eq conditional_level
    end
  end

  specify('lexer conditional mixed nesting') do
    regexp = '((?<A>a)(?<B>(?(<A>)b|((?(<B>)[e-g]|[h-j])))))'
    tokens = RL.lex(regexp)

    [
      [ 0, :group,       :capture,          '(',       0,  1, 0, 0, 0],
      [ 1, :group,       :named,            '(?<A>',   1,  6, 1, 0, 0],

      [ 5, :conditional, :open,             '(?',     13, 15, 2, 0, 0],
      [ 6, :conditional, :condition,        '(<A>)',  15, 20, 2, 0, 1],
      [ 8, :conditional, :separator,        '|',      21, 22, 2, 0, 1],

      [10, :conditional, :open,             '(?',     23, 25, 3, 0, 1],
      [11, :conditional, :condition,        '(<B>)',  25, 30, 3, 0, 2],

      [12, :set,         :open,             '[',      30, 31, 3, 0, 2],
      [13, :literal,     :literal,          'e',      31, 32, 3, 1, 2],
      [14, :set,         :range,            '-',      32, 33, 3, 1, 2],
      [15, :literal,     :literal,          'g',      33, 34, 3, 1, 2],
      [16, :set,         :close,            ']',      34, 35, 3, 0, 2],

      [17, :conditional, :separator,        '|',      35, 36, 3, 0, 2],
      [23, :conditional, :close,            ')',      41, 42, 3, 0, 1],
      [25, :conditional, :close,            ')',      43, 44, 2, 0, 0],

      [26, :group,       :close,            ')',      44, 45, 1, 0, 0],
      [27, :group,       :close,            ')',      45, 46, 0, 0, 0]
    ].each do |index, type, token, text, ts, te, level, set_level, conditional_level|
      struct = tokens.at(index)

      expect(struct.type).to eq type
      expect(struct.token).to eq token
      expect(struct.text).to eq text
      expect(struct.ts).to eq ts
      expect(struct.te).to eq te
      expect(struct.level).to eq level
      expect(struct.set_level).to eq set_level
      expect(struct.conditional_level).to eq conditional_level
    end
  end

  specify('lexer conditional deep nesting') do
    regexp = '(a(b(c)))(?(1)(?(2)(?(3)d|e))|(?(3)(?(2)f|g)|(?(1)f|g)))'
    tokens = RL.lex(regexp)

    [
      [ 9, :conditional, :open,       '(?',    9, 11, 0, 0, 0],
      [10, :conditional, :condition,  '(1)',  11, 14, 0, 0, 1],

      [11, :conditional, :open,       '(?',   14, 16, 0, 0, 1],
      [12, :conditional, :condition,  '(2)',  16, 19, 0, 0, 2],

      [13, :conditional, :open,       '(?',   19, 21, 0, 0, 2],
      [14, :conditional, :condition,  '(3)',  21, 24, 0, 0, 3],

      [16, :conditional, :separator,  '|',    25, 26, 0, 0, 3],

      [18, :conditional, :close,      ')',    27, 28, 0, 0, 2],
      [19, :conditional, :close,      ')',    28, 29, 0, 0, 1],

      [20, :conditional, :separator,  '|',    29, 30, 0, 0, 1],

      [21, :conditional, :open,       '(?',   30, 32, 0, 0, 1],
      [22, :conditional, :condition,  '(3)',  32, 35, 0, 0, 2],

      [23, :conditional, :open,       '(?',   35, 37, 0, 0, 2],
      [24, :conditional, :condition,  '(2)',  37, 40, 0, 0, 3],

      [26, :conditional, :separator,  '|',    41, 42, 0, 0, 3],

      [28, :conditional, :close,      ')',    43, 44, 0, 0, 2],

      [29, :conditional, :separator,  '|',    44, 45, 0, 0, 2],

      [30, :conditional, :open,       '(?',   45, 47, 0, 0, 2],
      [31, :conditional, :condition,  '(1)',  47, 50, 0, 0, 3],

      [33, :conditional, :separator,  '|',    51, 52, 0, 0, 3],

      [35, :conditional, :close,      ')',    53, 54, 0, 0, 2],
      [36, :conditional, :close,      ')',    54, 55, 0, 0, 1],
      [37, :conditional, :close,      ')',    55, 56, 0, 0, 0]
    ].each do |index, type, token, text, ts, te, level, set_level, conditional_level|
      struct = tokens.at(index)

      expect(struct.type).to eq type
      expect(struct.token).to eq token
      expect(struct.text).to eq text
      expect(struct.ts).to eq ts
      expect(struct.te).to eq te
      expect(struct.level).to eq level
      expect(struct.set_level).to eq set_level
      expect(struct.conditional_level).to eq conditional_level
    end
  end
end
