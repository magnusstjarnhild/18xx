# frozen_string_literal: true

module Engine
  module Part
    class Node < Base
      attr_accessor :lanes

      BITS_PER_GROUP = 52 # max safe JS integer size

      def self.init_visited
        @@node_walk_counter ||= 0
        @@node_walk_counter += 1
        @@node_counter = 0
        []
      end

      def clear!
        @paths = nil
        @exits = nil
      end

      def solo?
        @tile.nodes.one?
      end

      def paths
        @paths ||= @tile.paths.select { |p| p.nodes.any? { |n| n == self } }
      end

      def exits
        @exits ||= paths.flat_map(&:exits)
      end

      def rect?
        false
      end

      # visited? must be called before mark and unmark
      def visited?(visited)
        if visited.is_a?(Hash)
          visited[self]
        else
          unless @node_walk_signature == @@node_walk_counter
            @node_walk_signature = @@node_walk_counter
            @node_group = @@node_counter.div(BITS_PER_GROUP)
            @node_index = @@node_counter % BITS_PER_GROUP
            @@node_counter += 1
          end
          visited[@node_group] = 0 unless visited[@node_group]
          ((visited[@node_group] >> @node_index) & 1) == 1
        end
      end

      def mark_visited(visited)
        if visited.is_a?(Hash)
          visited[self] = true
        else
          visited[@node_group] |= (1 << @node_index)
        end
      end

      def force_visited(visited)
        if visited.is_a?(Hash)
          visited[self] = true
        else
          visited[@node_group] |= (1 << @node_index) unless visited?(visited)
        end
      end

      def unmark_visited(visited)
        if visited.is_a?(Hash)
          visited.delete(self)
        else
          visited[@node_group] = (visited[@node_group] | (1 << @node_index)) ^ (1 << @node_index)
        end
      end

      # Explore the paths and nodes reachable from this node
      #
      # visited: a hashset of visited Nodes
      # corporation: If set don't walk on adjacent nodes which are blocked for the passed corporation
      # visited_paths: a hashset of visited Paths
      # counter: a hash tracking edges and junctions to avoid reuse
      # skip_track: If passed, don't walk on track of that type (ie: :broad track for 1873)
      # converging_path: When true, some predecessor path was part of a converging switch
      #
      # This method recursively bubbles up yielded values from nested Node::Walk and Path::Walk calls
      def walk(
        visited: {},
        corporation: nil,
        visited_paths: {},
        skip_paths: nil,
        counter: Hash.new(0),
        skip_track: nil,
        converging_path: true,
        &block
      )
        return if visited?(visited)

        mark_visited(visited)

        paths.each do |node_path|
          next if node_path.track == skip_track
          next if node_path.ignore?

          node_path.walk(
            visited: visited_paths,
            skip_paths: skip_paths,
            counter: counter,
            converging: converging_path,
          ) do |path, vp, ct, converging|
            ret = yield path, vp, visited
            next if ret == :abort
            next if path.terminal?

            path.nodes.each do |next_node|
              next if next_node == self
              next if corporation && next_node.blocks?(corporation)

              next_node.walk(
                visited: visited,
                counter: ct,
                corporation: corporation,
                visited_paths: vp,
                skip_track: skip_track,
                skip_paths: skip_paths,
                converging_path: converging_path || converging,
                &block
              )
            end
          end
        end

        unmark_visited(visited) if converging_path
      end
    end
  end
end
