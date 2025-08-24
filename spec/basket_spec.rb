# frozen_string_literal: true
require "spec_helper"

RSpec.describe Acme::Basket do
  let(:products) do
    [
      Acme::Domain::Product.new(code: "R01", name: "Red Widget",   price: "32.95"),
      Acme::Domain::Product.new(code: "G01", name: "Green Widget", price: "24.95"),
      Acme::Domain::Product.new(code: "B01", name: "Blue Widget",  price: "7.95")
    ]
  end

  let(:catalogue) { Acme::Domain::Catalogue.new(products) }
  let(:delivery_rules) do
    Acme::Pricing::DeliveryRules.new([
      Acme::Pricing::DeliveryRules::Tier.new(predicate: ->(s) { s <  50.to_d }, cost: "4.95"),
      Acme::Pricing::DeliveryRules::Tier.new(predicate: ->(s) { s <  90.to_d }, cost: "2.95"),
      Acme::Pricing::DeliveryRules::Tier.new(predicate: ->(s) { s >= 90.to_d }, cost: "0.00")
    ])
  end
  let(:offers) { [Acme::Pricing::Offers::BuyOneGetSecondHalf.new(product_code: "R01")] }
  let(:basket) { described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers) }

  it "raises on unknown product code" do
    expect { basket.add("NOPE") }.to raise_error(Acme::Support::UnknownProductCode)
  end

  it "normalizes codes and ignores whitespace" do
    expect { basket.add(" r01 ").add("G01") }.not_to raise_error
  end

  it "formats totals with two decimals" do
    expect(basket.add("B01").total).to match(/\$\d+\.\d{2}/)
  end

  it "handles empty basket (no delivery charged)" do
    expect(described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers).total).to eq("$0.00")
  end

  context "offer and delivery rules examples" do
    it { expect(described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers).add("B01").add("G01").total).to eq("$37.85") }
    it { expect(described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers).add("R01").add("R01").total).to eq("$54.37") }
    it { expect(described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers).add("R01").add("G01").total).to eq("$60.85") }
    it { expect(described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers).add("B01").add("B01").add("R01").add("R01").add("R01").total).to eq("$98.27") }
  end

  it "applies red widget discount per pair only (odd item full price)" do
    b = described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: offers)
    3.times { b.add("R01") }
    expect(b.total).to eq("$85.32")
  end

  it "never lets discounts make subtotal negative" do
    silly_offer = Class.new(Acme::Pricing::Offers::Offer) do
      def discount(*)
        1_000.to_d
      end
    end.new

    b = described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: [silly_offer])
    b.add("B01")
    expect(b.total).to eq("$0.00")
  end

  it "respects tier boundaries exactly" do
    b = described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: [])
    b.add("G01").add("B01").add("B01") # 40.85
    expect(b.total).to eq("$45.80")

    b2 = described_class.new(catalogue: catalogue, delivery_rules: delivery_rules, offers: [])
    b2.add("G01").add("G01").add("B01") # 57.85
    expect(b2.total).to eq("$60.80")
  end
end
