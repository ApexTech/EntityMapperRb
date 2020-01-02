require "spec_helper"

RSpec.describe EntityMapper::JsonAttributesSerializer do
  class InitializedFromHashAttributesAndJsonSerializable
    include EntityMapper::JsonAttributesSerializer

    def id
      1
    end

    def name
      "Jhon Doe"
    end

    def age
      99
    end

    attributes :id, :name, :age
  end

  class InheritefFromInitializedFromHashAttributesAndJsonSerializable < InitializedFromHashAttributesAndJsonSerializable
    def address
      "Death Valley"
    end

    attribute :address do |object|
      "Located at: #{object.address}"
    end
  end

  describe "Serialization on child classes" do
    subject { InitializedFromHashAttributesAndJsonSerializable.new }

    it "Serializes properties provided configured as serializable attributes" do
      expect(subject.as_json).to eq({
        age: 99,
        id: 1,
        name: "Jhon Doe",
      })

      expect(InitializedFromHashAttributesAndJsonSerializable.serializable_attributes).to eq([:id, :name, :age])
    end
  end

  describe "Serialization on grandchild classes" do
    subject { InheritefFromInitializedFromHashAttributesAndJsonSerializable.new }

    it "Serializes properties configured as serializable attributes on class and on superclass" do
      expect(subject.as_json).to eq({
        address: "Located at: Death Valley",
        age: 99,
        id: 1,
        name: "Jhon Doe",
      })

      expect(subject.class.superclass.serializable_attributes).to eq([:id, :name, :age])
      expect(subject.class.serializable_attributes).to eq([:id, :name, :age, :address])
    end
  end
end
