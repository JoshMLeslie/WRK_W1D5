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
  attr_reader :start_pos, :end_pos, :move_tree
  attr_accessor :visited_positions

  def initialize(start_pos)
    @start_pos = start_pos
    @visited_positions = [start_pos]
    @move_tree = PolyTreeNode.new(start_pos)
  end

  def build_move_tree
    # breadth first => queue, FIFO
    queue = [move_tree]
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
        queue.unshift(child) # push child into the- queue
      end
    end
      move_tree # return the built tree
  end

  def new_move_positions(pos)
    new_moves = KnightPathFinder.valid_moves(pos) - visited_positions
    self.visited_positions += new_moves
    new_moves
  end

  def find_path(end_pos)
    end_node = find_end_node(end_pos)
    trace_path_back(end_node)
  end

  def find_end_node(end_pos)
    move_tree.dfs(end_pos)
  end

  def trace_path_back(node)
    node.trace_to_root
  end

  def self.valid_moves(pos)
    possible_moves = OFFSETS.map{|offset| [pos[0] + offset[0], pos[1] + offset[1]] }

    possible_moves.select{|move| valid_pos(move)}
  end

  def self.valid_pos(pos)
    # pos = x,y
    #
    pos.all? {|coord| (0...8).include?(coord) }
  end

end # class end

if __FILE__ == $PROGRAM_NAME
  knight = KnightPathFinder.new([0, 0])
  knight.build_move_tree
  p knight.find_path([3,6])
end
