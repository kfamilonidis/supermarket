describe Supermarket do
  
  it 'is a module' do
  	expect(described_class).to be_a(Module)
  end

  describe Supermarket::Till do
    
    let(:empty_basket) { Supermarket::Basket.new }
    let(:item) { Supermarket::Item.new(name: 'Apples',price: 50) }

  	it 'should charge nothing for no items' do
 	  	expect(subject.checkout(empty_basket)).to eq(0)
	  end

		it 'should charge nothing for no items' do
			one_item_basket = empty_basket.add(item)
 	  	expect(subject.checkout(one_item_basket)).to eq(50)
	  end

  end

  describe Supermarket::Item do
    
  	subject { described_class.new(name: 'Foo', price: 0) }

  	it 'should have a price' do
 	  	expect(subject).to respond_to(:price)
	  end
  	it 'should have a name' do
 	  	expect(subject).to respond_to(:name)
	  end
  end

  describe Supermarket::Stocker do

    it 'should scan item into the inventory' do
    	# expect(subject.scan).to matcher
    end
  end

  describe Supermarket::Inventory do 

  	let(:item){ Supermarket::Item.new(name: 'Foo', price: 0)}

  	it 'tells how many items has of a kind' do
  		expect(subject.how_many?(item)).to eq(0)
  	end

  	it 'has one item if you add an item' do
  		immutable = subject.add(item)
  		expect(immutable.how_many?(item)).to eq(1)
  	end

  	it 'has an item lists' do
  		expect(subject.item_list).to eq([])
  	end

  	it 'adds an item tyo the list' do
  		empty = described_class.new
  		immutable = described_class.new(empty,item)
  		expect(immutable.item_list).to match_array([item])
  	end

  end

  describe Supermarket::Basket do 

  	it 'is an inventory' do
  		expect(subject).to be_a(Supermarket::Inventory)
  	end
  end

end