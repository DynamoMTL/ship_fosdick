class TestShipment
  def initialize
    @file = File.read(file_path)
    @first_line = File.readlines(file_path).second.chomp
  end

  def generate(order)
    add_shipments(order)
  end

  private

  attr_reader :file, :first_line

  def add_shipments(order)
    file << "\n#{first_line.sub(/^H\d*/, order.shipments.first.number)}"
  end

  def file_path
    "#{File.dirname(__FILE__)}/test_shipment.txt"
  end
end
