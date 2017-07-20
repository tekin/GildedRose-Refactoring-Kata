class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when 'Sulfuras, Hand of Ragnaros'
        SulfurasRules.new(item).update
      when 'Aged Brie'
        AgedBrieRules.new(item).update
      when 'Backstage passes to a TAFKAL80ETC concert'
        BackStageRules.new(item).update
      else
        DefaultRules.new(item).update
      end

      apply_quality_limit(item)
    end
  end

  class DefaultRules
    attr_reader :item

    def initialize(item)
      @item = item
    end

    def update
      decrease_sell_in
      update_quality
    end

    def decrease_sell_in
      item.sell_in = item.sell_in - 1
    end

    def update_quality
      if item.sell_in < 0
        item.quality = item.quality - 2
      else
        item.quality = item.quality - 1
      end
    end

  end

  class SulfurasRules < DefaultRules
    def update
    end
  end

  class AgedBrieRules < DefaultRules

    def update_quality
      item.quality = item.quality + 1
    end
  end

  class BackStageRules < DefaultRules
    def update_quality
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
  end

  private

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
