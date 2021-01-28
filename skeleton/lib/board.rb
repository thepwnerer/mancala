class Board
  attr_accessor :cups
  attr_reader :name1, :name2

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) { [] }
    place_stones
  end

  def place_stones
    self.cups.each_with_index.map { |y,i| case when i != 6 && i != 13 
      then self.cups[i] = [:stone, :stone, :stone, :stone] end }
  end

  def valid_move?(start_pos)
      unless start_pos.between?(0,13)
        raise ArgumentError.new "Invalid starting cup"
      end
      if self.cups[start_pos].empty? == true
        raise ArgumentError.new "Starting cup is empty"
      end
  end

  def make_move(start_pos, current_player_name)
    end_pos = 0
    self.cups[start_pos].each_with_index.map { |stone,i| case 
      when start_pos + i != 6 && start_pos + i != 13 then
        self.cups[(start_pos + i) % 14] << stone
      when start_pos + i == 6 && current_player_name == self.name1 then
        self.cups[6] << stone
      when start_pos + i == 13 && current_player_name == self.name2 then
        self.cups[13] << stone
      when start_pos + i == 13 && current_player_name == self.name1 || start_pos + i == 6 && current_player_name == self.name2 then
      #this essentially skips a cup if it is not the player's store. I know it's ugly, but it works 
        self.cups[start_pos] << :stone
      end
      end_pos = (start_pos + i) % 14 }
      self.cups[start_pos] = []
      render
=begin
      p "Name 1: " + self.name1
      p "Name 2: " + self.name2
      p "Current Player: " + current_player_name
      p "start pos: " + start_pos.to_s
      p "ending pos: " + end_pos.to_s
=end
    p "end pos " + end_pos.to_s
      next_turn(end_pos, current_player_name)
    end

  def next_turn(ending_cup_idx, current_player_name)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if self.name1 == current_player_name && ending_cup_idx == 6 || self.name2 == current_player_name && ending_cup_idx == 13
      return :prompt
    elsif self.cups[ending_cup_idx].length == 1
      return :switch
    elsif self.cups[ending_cup_idx].length > 1
      return ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    side1 = [self.cups[7],self.cups[8],self.cups[9],self.cups[10],self.cups[11],self.cups[12]]
    side2 = [self.cups[0],self.cups[1],self.cups[2],self.cups[3],self.cups[4],self.cups[5]]
    if side1.all? { |cup| cup.empty? } || side2.all? { |cup| cup.empty? }
      return true
    end
    false
  end

  def winner
    if self.cups[6].length > self.cups[13].length
      return self.name1
    elsif self.cups[6].length < self.cups[13].length
      return self.name2
    end
      :draw
  end
end


