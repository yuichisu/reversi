require 'minitest/autorun'
require_relative '../lib/rboard'
class SampleTest < Minitest::Test
  def   test_init
    b = Rboard.new
    assert_equal 8, b.board.size, 'board should have 8 rows'
    8.times do |i|
      assert_equal 8, b.board[i].size, 'board should have 8 columns'
    end
  end

  def test_enumarate
    b = Rboard.new
    assert_equal 2, b.num(1), '2 brack pieces on initial condition'
    assert_equal 2, b.num(2), '2 white pieces on initial condition'
    assert_equal 60, b.num(0), '60 empty spaces on initial condition'
  end

  def test_checkdir
    b = Rboard.new
    assert_equal 1, b.check_dir(2, 2, 3, 1, 0)
    assert_equal 0, b.check_dir(1, 2, 3, 1, 0)
    assert_equal 1, b.check_dir(2, 3, 2, 0, 1)
  end

  def test_set_piece
    b = Rboard.new
    pp b.board
    assert_equal 1, b.set_piece(2, 2, 3)
    pp b.board
    assert_equal 1, b.set_piece(1, 4, 2)
    pp b.board
    assert_equal 1, b.set_piece(2, 5, 2)
    pp b.board
    assert_equal 1, b.set_piece(1, 6, 2)
    pp b.board
    assert_equal 1, b.set_piece(2, 6, 1)
    pp b.board
  end

  def test_import_board
    b = Rboard.new
    pp b.board
    b.board = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 0, 0, 0, 0],
      [0, 1, 1, 2, 2, 0, 0, 0],
      [0, 1, 1, 1, 2, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]
    assert_equal 3, b.num(2)
  end

  def test_search_board
    b = Rboard.new
    pp b.board
    b.board = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 0, 0, 0, 0],
      [0, 1, 1, 2, 2, 0, 0, 0],
      [0, 1, 1, 2, 2, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]
    assert_equal [3, 7, 0], b.search_max_pos(2)
  end
  def test_search_board2
    b = Rboard.new
    pp b.board
    b.board = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 0, 0, 0, 0],
      [0, 1, 1, 2, 2, 0, 0, 0],
      [0, 1, 1, 2, 2, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]
    assert_equal [2, 0, 0], b.search_max_pos2(2)
  end
  def test_show
    b = Rboard.new
    pp b.board
    b.board = [
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 0, 0, 0, 0],
      [0, 1, 1, 2, 2, 0, 0, 0],
      [0, 1, 1, 2, 2, 0, 0, 0],
      [0, 1, 1, 1, 1, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0]
    ]
    b.show
  end
end
