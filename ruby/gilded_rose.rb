class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Sulfuras, Hand of Ragnaros'
        next
      when 'Aged Brie'
        item.sell_in = item.sell_in - 1
        item.quality = item.quality + 1
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.sell_in = item.sell_in - 1
        update_backstage_quality(item)
      else
        item.sell_in = item.sell_in - 1
        decrease_quality(item)
      end

      apply_quality_limit(item)
    end
  end

  private

  def decrease_quality(item)
    if item.sell_in < 0
      item.quality = item.quality - 2
    else
      item.quality = item.quality - 1
    end
  end

  def update_backstage_quality(item)
    if item.sell_in < 0
      item.quality = item.quality - item.quality
    else
      item.quality = item.quality + 1
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
