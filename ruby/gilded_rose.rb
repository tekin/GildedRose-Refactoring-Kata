class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Sulfuras, Hand of Ragnaros'
        next
      else
        item.sell_in = item.sell_in - 1
        modify_quality(item)
      end
    end
  end

  private

  def modify_quality(item)
    # decreaes in qaulity if it's an item that decreases with age
    if item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert"
      # decrease quantity
      item.quality = item.quality - 1
    else
      # increase by one by default
      item.quality = item.quality + 1

      # additional increases for a back stage pass
      if item.name == "Backstage passes to a TAFKAL80ETC concert"
        # less than 11 days away
        if item.sell_in < 11
          item.quality = item.quality + 1
        end
        # less than 6 days away
        if item.sell_in < 6
          item.quality = item.quality + 1
        end
      end
    end

    # Passed the sell by date: maturing items get more love; backstage gets none
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != "Backstage passes to a TAFKAL80ETC concert"
          item.quality = item.quality - 1
        else
          item.quality = item.quality - item.quality
        end
      else
        item.quality = item.quality + 1
      end
    end
    apply_quality_limit(item)
  end

  def apply_quality_limit(item)
    item.quality = [[50, item.quality].min, 0].max
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
