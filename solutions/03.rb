class Sequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end
end

class RationalSequence < Sequence
  def each
    (1..Float::INFINITY).lazy.flat_map do |n|
      enum_for(:generate_nth_diagonal, n).to_a
    end.take(@limit).each { |rational| yield rational }
  end

  private
  def generate_nth_diagonal(n)
    range = n.odd? ? 1.upto(n) : n.downto(1)

    range.each do |numerator|
      denominator = n - numerator + 1
      unless encountered_before?(numerator, denominator)
        yield Rational(numerator, denominator)
      end
    end
  end

  def encountered_before?(numerator, denominator)
    ((multiples_of numerator) & (multiples_of denominator)).any?
  end

  def multiples_of(number)
    (2..number).select { |n| number % n == 0 }
  end
end

class Integer
  def prime?
    (1..self ** 0.5).one? { |divisor| self % divisor == 0 }
  end
end

class PrimeSequence < Sequence
  def each
    (2..Float::INFINITY).lazy.select(&:prime?).take(@limit).each { |prime| yield prime }
  end
end

class FibonacciSequence < Sequence
  include Enumerable

  def initialize(limit, first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    previous, current = @first, @second
    @limit.times do
      yield previous
      current, previous = current + previous, current
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    primeish, non_primeish = RationalSequence.new(n).partition do |rational|
      rational.numerator.prime? or rational.denominator.prime?
    end
    (primeish.reduce(1, :*) / non_primeish.reduce(1, :*))
  end

  def aimless(n)
    PrimeSequence.new(n).each_slice(2).map do |pair|
      pair.length == 2 ? Rational(pair.first, pair.last) : Rational(pair.first, 1)
    end.reduce(:+)
  end

  def worthless(n)
    nth_fibonacci = FibonacciSequence.new(n).to_a.last
    (1..Float::INFINITY).lazy.map do |i|
      RationalSequence.new(i).to_a
    end.take_while do |sequence|
      sequence.reduce(:+) <= nth_fibonacci
    end.to_a.last
  end
end