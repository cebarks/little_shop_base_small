require 'rails_helper'

RSpec.describe Cart do
  it '.total_count' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })
    expect(cart.total_count).to eq(5)
  end

  it '.count_of' do
    cart = Cart.new({})
    expect(cart.count_of(5)).to eq(0)

    cart = Cart.new({
      '2' => 3
    })
    expect(cart.count_of(2)).to eq(3)
  end

  it '.add_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.add_item(1)
    cart.add_item(2)
    cart.add_item(3)

    expect(cart.contents).to eq({
      '1' => 3,
      '2' => 4,
      '3' => 1
      })
  end

  it '.subtract_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.subtract_item(1)
    cart.subtract_item(1)
    cart.subtract_item(2)

    expect(cart.contents).to eq({
      '2' => 2
      })
  end

  it '.remove_all_of_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.remove_all_of_item(1)

    expect(cart.contents).to eq({
      '2' => 3
    })
  end

  it '.items' do
    item_1, item_2 = create_list(:item, 2)
    cart = Cart.new({})
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)

    expect(cart.items).to eq([item_1, item_2])
  end

  describe '.subtotal' do
    it "normal" do
      item_1 = create(:item)
      cart = Cart.new({})
      cart.add_item(item_1.id)
      cart.add_item(item_1.id)
      cart.add_item(item_1.id)

      expect(cart.subtotal(item_1.id)).to eq(item_1.price * cart.total_count)
    end

    it "with flat discount" do
      item_1 = create(:item)
      discount = Discount.create!(user: item_1.user, discount: 3, quantity: 3, discount_type: 'Flat')

      cart = Cart.new({})
      cart.add_item(item_1.id)
      cart.add_item(item_1.id)
      cart.add_item(item_1.id)

      expect(cart.subtotal(item_1.id)).to eq((item_1.price * cart.total_count) - discount.discount)
    end
    
    it "with percentage discount" do
      item_1 = create(:item)
      discount = Discount.create!(user: item_1.user, discount: 50, quantity: 3, discount_type: 'Percentage')

      cart = Cart.new({})
      cart.add_item(item_1.id)
      cart.add_item(item_1.id)
      cart.add_item(item_1.id)

      expect(cart.subtotal(item_1.id)).to eq((item_1.price * cart.total_count) * (discount.discount.to_f / 100))
    end
  end

  it '.grand_total' do
    item_1, item_2 = create_list(:item, 2)
    cart = Cart.new({})
    cart.add_item(item_1.id)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)

    expect(cart.grand_total).to eq(cart.subtotal(item_1.id) + cart.subtotal(item_2.id))
  end

  it '.discount?' do
    cart = Cart.new({})
    item_1, item_2 = create_list(:item, 2, inventory: 100)
    5.times do
      cart.add_item(item_1.id)
    end

    cart.add_item(item_2.id)
    discount_1 = Discount.create!(user: item_1.user, discount_type: 'Flat', discount: 10, quantity: 3)

    expect(cart.discount?(item_1.id)).to eq(discount_1)
    expect(cart.discount?(item_2.id)).to be_falsey
  end
end
