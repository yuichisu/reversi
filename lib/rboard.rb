class Rboard
  attr_accessor :board

  def initialize
    @board = [[0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 2, 1, 0, 0, 0],
              [0, 0, 0, 1, 2, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0]]
    @dir = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end

  def num(type)
    cnt = 0
    @board.each do |row|
      row.each do |val|
        cnt += 1 if val == type
      end
    end
    cnt
  end

  def check_dir(type, r, c, dr, dc)
    cnt = 0
    op = 2 if type == 1
    op = 1 if type == 2

    cr = r
    cc = c

    step = 1
    # puts "step:#{step} cr:#{cr} cc:#{cc} cnt:#{cnt} piece:#{@board[cr][cc]} op:#{op} type:#{type}"
    while step != 10
      # puts "step:#{step} cr:#{cr} cc:#{cc} cnt:#{cnt} piece:#{@board[cr][cc]} op:#{op} type:#{type}"
      case step
      when 1 # check empty
        step = if @board[cr][cc] != 0
                 10
               else
                 2
               end
      when 2 # check range
        cr += dr
        cc += dc
        if cr > (@board.size - 1) || cr < 0 || cc > (@board[0].size - 1) || cc < 0
          cnt = 0
          step = 10
        else
          step = 3
        end
      when 3 # check piece
        if @board[cr][cc] == op
          cnt += 1
          step = 2
        # puts "count up"
        elsif @board[cr][cc] == type && cnt > 0
          step = 10
        else
          cnt = 0
          step = 10
        end
      when 10
      end
    end
    cnt
  end

  def dry_set_piece(type, r, c)
    dir = @dir
    # dry run
    cnt = 0
    dir.each do |d|
      cnt += check_dir(type, r, c, d[0], d[1])
      # puts "#{d} #{check_dir(type,r,c,d[0],d[1])}"
    end
    cnt
  end

  def eval_set_piece(type, r, c)
    dir = @dir
    # dry run
    op = 1
    op = 2 if type == 1
    cnt = 0
    opcnt = 0
    dir.each do |d|
      cnt += check_dir(type, r, c, d[0], d[1])

      # puts "#{d} #{check_dir(type,r,c,d[0],d[1])}"
    end
    if cnt > 0
      buf = Marshal.dump(@board)
      set_piece(type, r, c)

        8.times do |x|
          8.times do |y|
            subt=0
            dir.each do |d|
              subt += check_dir(op, x, y, d[0], d[1])
            end
            opcnt = [opcnt, subt].max
        end
      end
      @board = Marshal.load(buf)

    end
    [cnt, opcnt]
  end


  def search_max_pos(type)
    cnt = 0
    br = 0
    bc = 0
    8.times do |r|
      8.times do |c|
        next unless cnt < dry_set_piece(type, r, c)

        br = r
        bc = c
        cnt = dry_set_piece(type, r, c)
      end
    end
    [cnt, br, bc]
  end

  def search_max_pos2(type)
    corners = [[0, 0], [7, 0], [0, 7], [7, 7]]

    cnt = 0
    cntbuf = 0.0
    truecnt = 0
    br = 0
    bc = 0
    8.times do |r|
      8.times do |c|
        cntbuf = dry_set_piece(type, r, c)
        if cntbuf > 0
          corners.each do |item|
            dis = [(item[0] - r).abs, (item[1] - c).abs].max
            cntbuf = if dis == 0
                       10
                     elsif dis == 1
                       0.5
                     elsif dis == 2
                       2
                     else
                       cntbuf 
                     end
          end
        end
        # puts "#{r} #{c} #{cntbuf} #{cnt} #{truecnt}"
        next unless cnt < cntbuf

        # puts "update"
        br = r
        bc = c
        cnt = cntbuf
        truecnt = dry_set_piece(type, br, bc)
      end
    end
    [truecnt, br, bc]
  end

  def search_max_pos3(type)
    corners = [[0, 0], [7, 0], [0, 7], [7, 7]]
    #first = true
    cnt = -100
    
    truecnt = 0
    br = 0
    bc = 0
    ret =[]
    8.times do |r|
      8.times do |c|
        ret = eval_set_piece(type, r, c)
        cntbuf = -100.0
        if ret[0] > 0
          #if first == true
          #      br = r
          #      bc = c
          #      truecnt = dry_set_piece(type, br, bc)
          #      first = false
          #end
          cntbuf=ret[0]-ret[1]
          corners.each do |item|
            dis = [(item[0] - r).abs, (item[1] - c).abs].max
            cntbuf = if dis == 0
                       cntbuf = cntbuf + 2
                     elsif dis == 1
                       cntbuf = cntbuf - 3
                     elsif dis == 2
                       cntbuf = cntbuf + 4
                     else
                       cntbuf 
                     end
                     
          end
        end
         #puts "#{r} #{c} #{cntbuf} #{cnt} #{truecnt} #{ret}"
        next unless cnt < cntbuf

        if ret[0]>0
         #puts "update"
        br = r
        bc = c
        cnt = cntbuf
        truecnt = dry_set_piece(type, br, bc)
        end
      end
    end
    [truecnt, br, bc]
  end

  def set_piece(type, r, c)
    dir = @dir
    cnt = dry_set_piece(type, r, c)
    return 0 if cnt == 0

    dir.each do |d|
      check_dir(type, r, c, d[0], d[1]).times do |i|
        @board[r + d[0] * (i + 1)][c + d[1] * (i + 1)] = type
      end
    end
    @board[r][c] = type
    cnt
  end

  def show
    puts '     '
    puts '   A B C D E F G H'
    8.times do |r|
      buf = if r == 0
              ' '
            else
              ' '
            end
      print "#{buf}#{r+1}"

      8.times do |c|
        case @board[r][c]
        when 0
          print ' .'
        when 1
          print ' X'
        when 2
          print ' O'
        end
      end
      print "\n"
    end
  end

  def parse_pos_inp(inp)
    r=0
    c=0
    inp.chomp!
    return [false, 0, 0] if inp.is_a?(String) == false
    buf = inp.match(/([1-8])/)
    return [false, 0,0] if buf == nil
    r=(buf[0].to_i)-1
    buf = inp.match(/([A-Ha-h])/)
    return [false, 0,0] if buf == nil
    
    case buf[0].upcase
    when "A"
      c = 0
    when "B"
      c = 1
    when "C"
      c = 2
    when "D"
      c = 3
    when "E"
      c = 4
    when "F"
      c = 5
    when "G"
      c = 6
    when "H"
      c = 7
    end
    [true, r, c]
  end


end
