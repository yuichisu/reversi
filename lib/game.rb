require './lib/rboard'
r = Rboard.new

step = 1
cur = 1
you = 1
r.show
while step != 10
  case step
  when 1
    buf = [[], [], []]
    buf[1] = r.search_max_pos(1)
    buf[2] = r.search_max_pos2(2)
    step = if buf[1][0] == 0 && buf[2][0] == 0
             9
           else
             2
           end
  when 2
    if buf[cur][0] == 0
      puts 'PASS!!'
    elsif cur != you
      puts "== PC's turn =="
      r.set_piece(cur, buf[cur][1], buf[cur][2])
    else
      yr = 0
      yc = 0
      cnt = 0
      puts '== Your turn (X) =='
      while cnt == 0
        print 'rc?'
        y = gets.to_i
        yc = y % 10
        yr = (y - yc) / 10
        # puts "#{y} #{yr} #{yc}"
        if yr < 0 || yr > 7 || yc < 0 || yc > 7
        else
          cnt = r.dry_set_piece(you, yr, yc)
        end
      end
      r.set_piece(cur, yr, yc)

      puts
    end
    r.show
    # sleep 1

    cur = if cur == 1
            2
          else
            1
          end
    step = 1
  when 9
    puts 'GAME SET'
    bn = r.num(1)
    wn = r.num(2)
    puts "Black #{bn} White #{wn}"
    if bn > wn
      puts 'Black Won!'
    elsif bn < wn
      puts 'White won!'
    else
      puts 'Even!'
    end
    step = 10
  end
end
