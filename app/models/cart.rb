class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def total_count
    @contents.values.sum
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def add_item(item_id)
    @contents[item_id.to_s] ||= 0
    @contents[item_id.to_s] += 1
  end

  def subtract_item(item_id)
    @contents[item_id.to_s] -= 1
    @contents.delete(item_id.to_s) if @contents[item_id.to_s] == 0
  end

  def remove_all_of_item(item_id)
    @contents.delete(item_id.to_s)
  end

  def items
    @contents.keys.map do |item_id|
      Item.includes(:user).find(item_id)
    end
  end

  def subtotal(item_id)
    item = Item.find(item_id)
    if discount = discount?(item_id)
      price = case discount.discount_type
      when 'Flat'
        (item.price * count_of(item_id)) - discount.discount
      when 'Percentage'
        (item.price * count_of(item_id)) - ((item.price * count_of(item_id)) * (discount.discount.to_f / 100))
      end
      
      if price < 0
        price = 0
      end
      price
    else
      item.price * count_of(item_id)
    end
  end

  def grand_total
    @contents.keys.map do |item_id|
      subtotal(item_id)
    end.sum
  end

  def discount?(item_id)
    item = Item.find(item_id)
    cart_qty = @contents[item_id.to_s]

    return nil unless cart_qty

    Discount.has_discount?(item, cart_qty)
  end
end
