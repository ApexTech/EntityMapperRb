require "spec_helper"
require 'date'
require "time"

RSpec.describe EntityMapper::AttributesFromHashInitializer do
  class InitializedFromHashAttributes
    include EntityMapper::AttributesFromHashInitializer

    initializable_attributes :id, :name

    initializable_attribute :age, :Float
  end

  class InheritefFromInitializedFromHashAttributes < InitializedFromHashAttributes
    def self.Address(value)
      Address.new(value)
    end

    class Address
      include EntityMapper::AttributesFromHashInitializer

      initializable_attributes :street
    end

    initializable_attribute :address, "InheritefFromInitializedFromHashAttributes::Address"
  end

  class InitializedFromHashAttributesAndMapsPropertiesToAlias
    include EntityMapper::AttributesFromHashInitializer

    initializable_attributes :name, { id: :_id }

    initializable_attribute :age, :Float, key: :edad
    initializable_attribute :favorite_date, :Time, method: :strptime, args: ["%d of %B %Y"]
    initializable_attribute :birthday, :DateTime, method: :strptime, args: ["%d of %B %Y"]
  end

  describe "attribute initialization on child class" do
    let(:attributes) do
      {
        id: 1,
        name: "Jhon Doe",
        age: 99,
      }
    end

    subject { InitializedFromHashAttributes.new(attributes) }

    it "Initializes properties on class from attrs provided to class initializer" do
      expect(subject.id).to eq(1)
      expect(subject.age).to eq(99.0)
      expect(subject.age).to be_a(Float)
      expect(subject.name).to eq("Jhon Doe")

      expect(subject.class.initializable_attributes_list).to eq([:id, :name, :age])
    end
  end

  describe "attribute initialization on grandchild class" do
    let(:attributes) do
      {
        id: 1,
        name: "Jhon Doe",
        age: 99,
        address: {
          street: "Death Valley",
        },
      }
    end

    subject { InheritefFromInitializedFromHashAttributes.new(attributes) }

    it "Initializes properties on child classes inheriting defined props from parent class while not messing up the defined properties on parent class" do
      expect(subject.id).to eq(1)
      expect(subject.age).to eq(99)
      expect(subject.name).to eq("Jhon Doe")
      expect(subject.address.street).to eq("Death Valley")

      expect(subject.class.superclass.initializable_attributes_list).to eq([:id, :name, :age])
      expect(subject.class.initializable_attributes_list).to eq([:id, :name, :age, :address])
    end
  end

  describe "attribute initialization with alias mapping and attributes with custom initializers" do
    let(:attributes) do
      {
        _id: 1,
        name: "Jhon Doe",
        edad: 99,
        favorite_date: "1 of December 2017",
        birthday: "14 of December 1989",
      }
    end

    subject { InitializedFromHashAttributesAndMapsPropertiesToAlias.new(attributes) }

    it "Initializes properties on class from attrs provided to class initializer" do
      expect(subject.id).to eq(1)
      expect(subject.age).to eq(99.0)
      expect(subject.age).to be_a(Float)
      expect(subject.favorite_date).to be_a(Time)
      expect(subject.favorite_date).to eq(Time.parse("2017-12-01 00:00:00 -0400"))
      expect(subject.favorite_date).to be_a(Time)
      expect(subject.birthday).to eq(DateTime.parse("1989-12-14 00:00:00"))
      expect(subject.name).to eq("Jhon Doe")

      expect(subject.class.initializable_attributes_list).to match_array([:id, :name, :age, :favorite_date, :birthday])
    end
  end
end
