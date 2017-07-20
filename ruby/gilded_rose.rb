class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      modify_sell_in(item)
      modify_quality(item)
    end
  end

  private

  def modify_sell_in(item)
    # Sulfuras does not age
    if item.name != "Sulfuras, Hand of Ragnaros"
      item.sell_in = item.sell_in - 1
    end
  end

  def modify_quality(item)

    # decreaes in qaulity if it's an item that decreases with age
    if item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert"
      # quality is never negative
      if item.quality > 0
        # decrease quantity unless it's sulfuras, which never ages
        if item.name != "Sulfuras, Hand of Ragnaros"
          item.quality = item.quality - 1
        end
      end
    else
      # Do not change quality beyond 50
      if item.quality < 50
        # increase by one by default
        item.quality = item.quality + 1

        # additional increases for a back stage pass
        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          # less than 11 days away
          if item.sell_in < 11
            if item.quality < 50
              item.quality = item.quality + 1
            end
          end
          # less than 6 days away
          if item.sell_in < 6
            if item.quality < 50
              item.quality = item.quality + 1
            end
          end
        end
      end
    end

    # Passed the sell by date: maturing items get more love; backstage gets none
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != "Backstage passes to a TAFKAL80ETC concert"
          if item.quality > 0
            if item.name != "Sulfuras, Hand of Ragnaros"
              item.quality = item.quality - 1
            end
          end
        else
          item.quality = item.quality - item.quality
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
        end
      end
    end
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
