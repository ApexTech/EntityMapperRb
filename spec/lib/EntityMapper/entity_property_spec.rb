require "spec_helper"

RSpec.describe EntityMapper::EntityProperty do
  describe "initialization with name only" do
    subject { described_class.new(:property) }

    it "matches the given argument as the  property name, also assings data key equals with the same value of property name" do
      expect(subject.name).to eq(:property)
      expect(subject.key).to eq(:property)
      expect(subject.type).to be_nil
    end
  end

  describe "property alias" do
    subject { described_class.new({ property: :property_on_initial_structure }, :NullConversionMethodProxyForInitializer) }

    it "assigns property name and key property used to extract data from on initialization process" do
      expect(subject.name).to eq(:property)
      expect(subject.key).to eq(:property_on_initial_structure)
      expect(subject.type).to eq(:NullConversionMethodProxyForInitializer)
    end
  end

  describe "property type" do
    subject { described_class.new(:property, :String) }

    it "Assings the given property type as second argument" do
      expect(subject.name).to eq(:property)
      expect(subject.type).to eq(:String)
    end
  end

  describe "initialization_method_for_type" do
    context "Types with conversion methods" do
      [:String, :Integer, :Float, :BigDecimal, :Array, :Hash].each do |propery_type|
        subject { described_class.new(:property, propery_type) }

        it "Uses conversion method for: #{propery_type}" do
          expect(subject.name).to eq(:property)
          expect(subject.initialization_method_for_type).to be_nil
        end
      end
    end

    context "Types with parsers" do
      [:Date, :DateTime, :Time].each do |propery_type|
        subject { described_class.new(:property, propery_type) }

        it "Uses parser method for: #{propery_type}" do
          expect(subject.name).to eq(:property)
          expect(subject.initialization_method_for_type).to be(:parse)
        end
      end
    end

    context "Custom Initialization method on given type" do
      subject { described_class.new(:property, :DateTime, { method: :strptime }) }

      it "Uses custom initialization method" do
        expect(subject.name).to eq(:property)
        expect(subject.initialization_method_for_type).to be(:strptime)
      end
    end
  end
end
