require 'test_helper'

describe Day::Solutions::Day2 do
  before do
    @subject = Day::Solutions::Day2
    @params = {
      day: MiniTest::Mock.new,
    }
  end

  describe "as a class" do
    it "initializes properly" do
      @subject.new(@params).must_respond_to :call
    end

    it "errors when initialized without required dependencies" do
      -> { @subject.new(@params.reject { |k| k.to_s == 'day' }) }.must_raise RuntimeError
    end
  end

  describe "as an instance" do
    it "executes successfully" do
      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end
end