require "spec_helper"

RSpec.describe EntityMapper::Model do
  class ModelWithAttributes < EntityMapper::Model
    initializable_attributes :id, :name, :age
    attributes :id, :name, :age
  end

  class InheritefFromModelWithAttributes < ModelWithAttributes
    initializable_attributes :address

    attribute :address do |object|
      "Located at: #{object.address}"
    end
  end

  describe "Implementation on child class" do
    let(:attributes) do
      {
        id: 1,
        name: "Jhon Doe",
        age: 99,
      }
    end

    subject { ModelWithAttributes.new(attributes) }

    describe "attribute initialization" do
      it "Initializes properties on class from attrs provided to class initializer" do
        expect(subject.id).to eq(1)
        expect(subject.age).to eq(99)
        expect(subject.name).to eq("Jhon Doe")

        expect(subject.class.initializable_attributes_list).to eq([:id, :name, :age])
      end
    end

    describe "attribute serialization" do
      it "Serializes properties provided configured as serializable attributes" do
        expect(subject.as_json).to eq({
          age: 99,
          id: 1,
          name: "Jhon Doe",
        })

        expect(subject.class.serializable_attributes).to eq([:id, :name, :age])
      end
    end
  end

  describe "Implementation on grandchild class" do
    let(:attributes) do
      {
        id: 1,
        age: 99,
        name: "Jhon Doe",
        address: "Death Valley",
      }
    end

    subject { InheritefFromModelWithAttributes.new(attributes) }

    describe "attribute initialization" do
      it "Initializes properties on class from attrs provided to class initializer and superclass initializer" do
        expect(subject.id).to eq(1)
        expect(subject.age).to eq(99)
        expect(subject.name).to eq("Jhon Doe")

        expect(subject.class.superclass.initializable_attributes_list).to eq([:id, :name, :age])
        expect(subject.class.initializable_attributes_list).to eq([:id, :name, :age, :address])
      end
    end

    describe "attribute serialization" do
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
end
