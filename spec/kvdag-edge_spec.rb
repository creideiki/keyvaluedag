require 'spec_helper'
require 'attrnode_examples'

describe KVDAG::Edge do
  include_examples 'attributenodes', lambda {
    @dag = KVDAG.new
    v1 = @dag.vertex
    v2 = @dag.vertex
    v1.edge v2
  }
end
