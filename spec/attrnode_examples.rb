shared_examples 'attributenodes' do |node_proc|
  before :each do
    @node = node_proc.call
  end

  it 'is initially empty' do
    expect(@node.attrs).to be_empty
  end

  it 'can have simple attributes' do
    @node['attr'] = true
    expect(@node['attr']).to be true
  end

  it 'can have deep key path attributes' do
    @node['deep.key.path'] = true
    expect(@node['deep.key.path']).to be true
  end

  it 'returns remaining hash trees for incomplete key paths' do
    @node['deep.key.path'] = true
    expect(@node['deep.key']).to be_a Hash
    expect(@node['deep.key']['path']).to be true
  end

  it 'can convert its attributes to a regular hash tree' do
    @node['attr'] = @node['deep.key.path'] = true
    hsh = @node.to_hash
    expect(hsh['attr']).to be true
    expect(hsh['deep']['key']['path']).to be true
  end

  it 'can return a filtered set of key paths' do
    @node['attr'] = true
    @node['deep.key.path'] = true
    filtered = @node.filter('deep')
    expect(filtered.fetch('deep.key.path')).to be true
    expect{filtered.fetch('attr')}.to raise_error KeyError
  end

  context 'when matching against attribute rules' do
    before :each do
      @node = node_proc.call
      @node['attr1'] = true
      @node['attr2'] = true
    end

    it 'can match against none? of the rules' do
      expect(@node.match?(none?:{'attr1'=>false,'attr2'=>false})).to be true
      expect(@node.match?(none?:{'attr1'=>true,'attr2'=>false})).to be false
      expect(@node.match?(none?:{'attr1'=>false,'attr2'=>true})).to be false
      expect(@node.match?(none?:{'attr1'=>true,'attr2'=>true})).to be false
    end

    it 'can match against one? of the rules' do
      expect(@node.match?(one?:{'attr1'=>false,'attr2'=>false})).to be false
      expect(@node.match?(one?:{'attr1'=>true,'attr2'=>false})).to be true
      expect(@node.match?(one?:{'attr1'=>false,'attr2'=>true})).to be true
      expect(@node.match?(one?:{'attr1'=>true,'attr2'=>true})).to be false
    end

    it 'can match against any? of the rules' do
      expect(@node.match?(any?:{'attr1'=>false,'attr2'=>false})).to be false
      expect(@node.match?(any?:{'attr1'=>true,'attr2'=>false})).to be true
      expect(@node.match?(any?:{'attr1'=>false,'attr2'=>true})).to be true
      expect(@node.match?(any?:{'attr1'=>true,'attr2'=>true})).to be true
    end

    it 'can match against all? of the rules' do
      expect(@node.match?(all?:{'attr1'=>false,'attr2'=>false})).to be false
      expect(@node.match?(all?:{'attr1'=>true,'attr2'=>false})).to be false
      expect(@node.match?(all?:{'attr1'=>false,'attr2'=>true})).to be false
      expect(@node.match?(all?:{'attr1'=>true,'attr2'=>true})).to be true
    end
  end

  context 'when matching against methods' do
    before :each do
      @node = node_proc.call
      allow(@node).to receive(:test_ok).and_return(true)
      allow(@node).to receive(:test_error).and_raise(NoMethodError)
    end

    it 'can match against a method value' do
      expect(@node.match?(test_ok: true)).to be true
    end

    # FIXME: what should happen here?
    # be false or raise_error?
    # expect(@node.match(test_error: true))
  end

  context 'when merging' do
    it 'will be deeply merged' do
      @node['deep.key.path1'] = true
      @node.merge! deep:{key:{path2: true}}
      expect(@node['deep.key.path1']).to be true
      expect(@node['deep.key.path2']).to be true
    end

    it 'will overwrite duplicate key values' do
      @node['deep.key.path1'] = true
      @node.merge! deep:{key:{path1: false}}
      expect(@node['deep.key.path1']).to be false
    end

    it 'will not append duplicate key values' do
      @node['key'] = [1]
      @node.merge! key:[2]
      expect(@node['key']).to have(1).item
    end
  end
end
