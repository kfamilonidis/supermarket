describe Supermarket do

  it 'is a module' do
  	expect(described_class).to be_a(Module)
  end

  describe Supermarket::Till do
    let(:empty_basket) { Supermarket::Basket.new }
    let(:item) { Supermarket::Item.new(name: 'Apples',price: 50) }

    context 'no discount' do
      it 'has a discount list' do
        expect(subject.discount_list).to eq([])
      end

      it 'should charge nothing for no items' do
        expect(subject.checkout(empty_basket)).to eq(0)
      end

      it 'should charge 50 when a item cost 50' do
        one_item_basket = empty_basket.add(item)
        expect(subject.checkout(one_item_basket)).to eq(50)
      end

      it 'applies no discount when no discount list provided' do
        one_item_basket = empty_basket.add(item)
        expect(subject.apply_discount(one_item_basket.item_list)).to eq(one_item_basket.item_list)
      end
    end

    context 'discount' do

      let(:item2) { Supermarket::Item.new(name: 'Bananas',price: 30) }
      let!(:discount_list){ [
          Supermarket::Discount.new(item: item, quantity: 3, special_price: 130),
          Supermarket::Discount.new(item: item2, quantity: 2, special_price: 45)
       	]
      }
      subject do
        described_class.new(discount_list)
      end
      it 'applies discount when discount list provided' do
        new_basket = empty_basket.add(item2)
        new_basket = new_basket.add(item2)
        expect(subject.apply_discount(new_basket.item_list).first).to have_a_price_of(45)
      end
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

  describe Supermarket::Discount do

    let(:item){ Supermarket::Item.new(name: 'Foo', price: 50)}
    let(:other_item){ Supermarket::Item.new(name: 'Bazz', price: 0)}

    subject do
      described_class.new(item: item, quantity: 3, special_price: 130)
    end

    it 'checks the quantity of item' do
      basket = Supermarket::Basket.new
      3.times { basket = basket.add(item) }
      expect(subject).to be_applicable(basket.item_list)
    end

    it 'returns false when basket is empty' do
      empty_basket = Supermarket::Basket.new
      expect(subject).not_to be_applicable(empty_basket.item_list)
    end

    it 'return false when item is not the write one' do
      basket = Supermarket::Basket.new
      3.times { basket = basket.add(other_item) }
      expect(subject).not_to be_applicable(basket.item_list)
    end

    it 'return true when item has the same name' do
      same_different_instance = Supermarket::Item.new(name: 'Foo', price: 0)
      basket = Supermarket::Basket.new
      3.times { basket = basket.add(same_different_instance) }
      expect(subject).to be_applicable(basket.item_list)
    end

    it 'return a list of discounted item' do
      basket = Supermarket::Basket.new
      3.times { basket = basket.add(item) }
      expect(subject.apply(basket.item_list).first).to have_a_price_of(130)
    end

    it 'return a list of discounted item and the remain ones' do
      basket = Supermarket::Basket.new
      4.times { basket = basket.add(item) }
      list = subject.apply(basket.item_list)
      expect(list.first).to have_a_price_of(130)
      expect(list.last).to have_a_price_of(50)
    end

    it 'return a list of discounted item and the remain ones' do
      basket = Supermarket::Basket.new
      2.times { basket = basket.add(other_item) }
      4.times { basket = basket.add(item) }
      list = subject.apply(basket.item_list)
      expect(list).to match_array([other_item,other_item,item, Supermarket::Item.new(name: 'Foo',price: 130)])
    end
  end
end
