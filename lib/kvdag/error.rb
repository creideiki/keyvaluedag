class KVDAG
  # Vertices belong to different DAG:s

  class VertexError < StandardError
  end

  # Inserted edge would cause a cycle.

  class CyclicError < StandardError
  end
end
