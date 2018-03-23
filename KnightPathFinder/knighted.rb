require_relative "../polytreenode/lib/00_tree_node"

class KnightPathFinder

  OFFSETS = [
    [2,1],
    [2,-1],
    [1,-2],
    [1,2],
    [-1,2],
    [-1,-2],
    [-2,1],
    [-2,-1]
  ]
  attr_reader :start_pos, :end_pos
  attr_accessor :visited_positions

  def initialize(start_pos)
    @start_pos = start_pos
    @visited_positions = [start_pos]
  end

  def build_move_tree(end_pos)
    # breadth first => queue, FIFO
    root_node = PolyTreeNode.new(start_pos)
    queue = [root_node]
    until queue.empty?
      parent = queue.pop        # pull next parent_pos to generate children
      parent_pos = parent.value # => position value

      # new_move_pos:
      # generate possible moves from parent pos
      # updates visited positions to prevent backtracking
      next_moves = new_move_positions(parent_pos)

      next_moves.each do |move| # iterate through possible next moves
        # generate new children based on possible moves
        child = PolyTreeNode.new(move)

        child.parent = parent # update child's parent
        queue.unshift(child) # push child into the queue
      end
    end
      root_node # return the built tree
  end

  def new_move_positions(pos)
    new_moves = KnightPathFinder.valid_moves(pos) - visited_positions
    self.visited_positions += new_moves
    new_moves
  end

  def find_path(end_pos)

  end

  def self.valid_moves(pos)
    possible_moves = OFFSETS.map{|offset| [pos[0] + offset[0], pos[1] + offset[1]] }

    possible_moves.select{|move| valid_pos(move)}

  end

  def self.valid_pos(pos)
    # pos = x,y
    pos.all? {|coord| (0..8).include?(coord) }
  end

end # class end
