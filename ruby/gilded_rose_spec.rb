require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality with a standard item' do
    let!(:item) { Item.new('foo', 7, 5) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'does not change the name' do
      expect(items[0].name).to eq 'foo'
    end

    it 'decreases an item’s quality value' do
      expect(items[0].quality).to eq 4
    end

    it 'decreases an item’s sell_in value' do
      expect(items[0].sell_in).to eq 6
    end
  end

  # Once the sell by date has passed, Quality degrades twice as fast
  describe '#update_quality with an item that has reached the sell_in date' do
    let!(:item) { Item.new('foo', 0, 5) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'descreases the item‘s quality twice as fast' do
      expect(items[0].quality).to eq(3)
      expect(items[0].sell_in).to eq(-1)
    end
  end

  # The Quality of an item is never negative
  describe '#update_quality with an item that has zero quality' do
    let!(:item) { Item.new('foo', 5, 0) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'does not reduce the quality below zero' do
      expect(items[0].quality).to eq(0)
      expect(items[0].sell_in).to eq(4)
    end
  end

  # "Aged Brie" actually increases in Quality the older it gets
  describe '#update_quality with aged brie' do
    let!(:item) { Item.new('Aged Brie', 4, 2) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'increases the quality' do
      expect(items[0].quality).to eq(3)
      expect(items[0].sell_in).to eq(3)
    end
  end

  # The Quality of an item is never more than 50
  describe '#update_quality with aged brie with a quality of 50' do
    let!(:item) { Item.new('Aged Brie', 4, 50) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'will not increase quality above 50' do
      expect(items[0].quality).to eq(50)
      expect(items[0].sell_in).to eq(3)
    end
  end

  # "Sulfuras", being a legendary item, never has to be sold or decreases in
  # Quality
  describe '#update_quality with a Sulfuras, Hand of Ragnaros item' do
    let!(:item) { Item.new('Sulfuras, Hand of Ragnaros', 4, 40) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'does not decease in quality' do
      expect(items[0].quality).to eq(40)
    end

    it 'does not decrease in sell_in value' do
      expect(items[0].sell_in).to eq(4)
    end
  end

  # "Backstage passes", like aged brie, increases in Quality as its SellIn
  # value approaches; Quality increases by 2 when there are 10 days or less and
  # by 3 when there are 5 days or less but Quality drops to 0 after the concert
  describe '#update_quality with a Backstage pass that is more than 10 days away' do
    let!(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 12, 5) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'increases in quality' do
      expect(items[0].quality).to eq(6)
      expect(items[0].sell_in).to eq(11)
    end
  end

  describe '#update_quality with a Backstage pass that is 10 days away' do
    let!(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 5) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'increases in quality by 2' do
      expect(items[0].quality).to eq(7)
      expect(items[0].sell_in).to eq(9)
    end
  end

  describe '#update_quality with a Backstage pass that is 5 days away' do
    let!(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 5) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'increases in quality by 3' do
      expect(items[0].quality).to eq(8)
      expect(items[0].sell_in).to eq(4)
    end
  end

  describe '#update_quality with a Backstage pass that is 0 days away' do
    let!(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 5) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'drops quality to zero' do
      expect(items[0].quality).to eq(0)
      expect(items[0].sell_in).to eq(-1)
    end
  end

  describe '#update_quality with an item with zero quality and sell_in' do
    let!(:item) { Item.new('foo', 0, 0) }
    let!(:items) { [item] }
    before(:each) { GildedRose.new(items).update_quality }

    it 'does not decrease quality beyond zero' do
      expect(items[0].quality).to eq 0
    end

    it 'decreases an item’s sell_in value' do
      expect(items[0].sell_in).to eq -1
    end
  end
end
