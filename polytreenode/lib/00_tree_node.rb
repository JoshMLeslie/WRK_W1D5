require 'byebug'

class PolyTreeNode
  attr_reader :value, :children, :parent

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  # child will be deleted across the board
  #
  # child will be added to selected parent
  def parent=(node)
    remove_as_child
    @parent = node
    node.children << self if node
    node
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise ArgumentError unless children.include?(child_node)
    child_node.parent = nil
  end

  def dfs(target_value = nil, &prc)
    raise ArgumentError unless prc || target_value
    prc ||= Proc.new { |el| el.value == target_value }
    return self if prc.call(self)
    children.each do |child|
      found_child = child.dfs(target_value, &prc)
      return found_child if found_child
    end
    nil
  end

  def bfs(target_value = nil, &prc)
    raise ArgumentError unless prc || target_value
    prc ||= Proc.new { |el| el.value == target_value }

    child_queue = [self]

    while child_queue.count > 0
      check_node = child_queue.shift
      return check_node if prc.call(check_node)

      check_node.children.each do |child|
        child_queue << child if child
      end
    end
    nil
  end

  def trace_to_root
    return [self.value] if parent.nil?
    parent.trace_to_root + [self.value]
  end

  def render
    ready_to_print_values = all_descendant_values
    print_width = ready_to_print_values.last.to_s.length
    print_width += 10
    ready_to_print_values.each do |vals|
      puts "#{vals}".center(print_width)
    end
    # ? ? ? #
    #   middle_i = vals.length / 2
    #   left = vals.take(middle_i)
    #   right = vals.drop(middle_i)
    #   puts "#{left} || #{right}".center(print_width)
  end

  protected

  def all_descendant_values
    # returns nested arrays of tree values
    display_arr = [[self]]
    until display_arr.last.empty?
      new_row = []
      display_arr.last.each do |row_node|
        new_row += row_node.children
      end
      display_arr << new_row
    end
    display_arr.pop
    display_arr.map do |row_arr|
      row_arr.map { |node| node.value }
    end
  end

  def remove_as_child
    found_root = find_root
    parent = found_root.detect_parent(self)
    parent.children.delete(self) if parent
  end
  # moves through the tree
  # pass node into parent
  # if that node exists w/in its children
  # return that parent node
  # leads to => parent.remove_child
  def detect_parent(node)
    dfs { |el| el.children.include?(node) }
  end

  # recurse up the tree until root
  def find_root
    return self if parent.nil?
    parent.find_root
  end
end # class end

if __FILE__ == $PROGRAM_NAME
  nodes = (1..50).map { |value| PolyTreeNode.new(value) }

  parent_index = 0
  nodes.each_with_index do |child, index|
    next if index.zero?
    child.parent = nodes[parent_index]
    parent_index += 1 if index.even?
  end

  root = nodes[0]
  nodes[2].remove_child(nodes[3])
  root.render

  # p root.dfs { |el| el.value % 5 == 0 }
end
