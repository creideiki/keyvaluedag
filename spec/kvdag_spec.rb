require 'spec_helper'

describe KVDAG do
  it 'has a version number' do
    expect(KVDAG::VERSION).not_to be nil
  end

  context 'initially' do
    before :each do
      @dag = KVDAG.new
    end

    it 'exists' do
      expect(@dag).to be_a(KVDAG)
    end

    it 'has no vertices' do
      expect(@dag.vertices).to be_a(Set)
      expect(@dag.vertices).to be_empty
    end

    it 'has no edges' do
      expect(@dag.edges).to be_a(Set)
      expect(@dag.edges).to be_empty
    end
  end

  context 'with first vertex' do
    before :each do
      @dag = KVDAG.new
      @v1 = @dag.vertex
    end

    it 'has one vertex' do
      expect(@dag.vertices).to have(1).item
    end

    it 'has no edges' do
      expect(@dag.edges).to be_empty
    end
  end

  context 'with second vertex' do
    before :each do
      @dag = KVDAG.new
      @v1 = @dag.vertex
      @v2 = @dag.vertex
    end

    it 'has two vertices' do
      expect(@dag.vertices).to have(2).items
    end

    it 'has no edges' do
      expect(@dag.edges).to be_empty
    end

    it 'has unordered vertices' do
      expect(@v1 > @v2).to be false
      expect(@v1 < @v2).to be false
      expect(@v1 == @v2).to be true
    end
  end

  context 'with first edge' do
    before :each do
      @dag = KVDAG.new
      @v1 = @dag.vertex
      @v2 = @dag.vertex
      @v1.edge @v2
    end

    it 'is acyclic' do
      expect{ @v1.edge @v2 }.to_not raise_error
    end

    it 'has two vertices' do
      expect(@dag.vertices).to have(2).items
    end

    it 'has one edge' do
      expect(@dag.edges).to have(1).item
    end

    it 'has ordered vertices' do
      expect(@v1 > @v2).to be false
      expect(@v1 < @v2).to be true
      expect(@v1 == @v2).to be false
    end
  end

  context 'with second edge' do
    before :each do
      @dag = KVDAG.new
      @v1 = @dag.vertex
      @v2 = @dag.vertex
      @v1.edge @v2
    end

    it 'would become cyclic' do
      expect{ @v1.edge @v1 }.to raise_error KVDAG::CyclicError
      expect{ @v2.edge @v2 }.to raise_error KVDAG::CyclicError
      expect{
        @v2.edge @v1
      }.to raise_error KVDAG::CyclicError
    end
  end

  context 'when vertices and edges have attributes' do
    before :each do
      @dag = KVDAG.new
      @v1 = @dag.vertex(first: true)
      @v2 = @dag.vertex(second: true)
      @v1.edge @v2, edge: true
    end

    it 'can be filtered by vertex attribute' do
      expect(@dag.vertices(all?: {'first' => true})).to include @v1
      expect(@dag.vertices(all?: {'first' => true})).not_to include @v2
    end

    it 'can be filtered by edge attribute' do
      expect(@dag.vertices(all?: {'edge' => true})).to include @v1
      expect(@dag.vertices(all?: {'edge' => true})).not_to include @v2
    end

    it 'can be filtered by parent attribute' do
      expect(@dag.vertices(all?: {'second' => true})).to include @v1
      expect(@dag.vertices(all?: {'second' => true})).to include @v2
    end
  end
end
