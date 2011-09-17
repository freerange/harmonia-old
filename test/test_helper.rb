ENV["ENV"] = "test"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "harmonia"
require "test/unit"
require "mocha"
require "harmonia/mail"

class Test::Unit::TestCase
  private

  def store_path
    tmp_dir = File.expand_path("../../tmp", __FILE__)
    FileUtils.mkdir_p(tmp_dir)
    File.join(tmp_dir, "harmonia.yml")
  end

  def stub_free_agent!(invoices)
    Harmonia::Mail::Invoices.any_instance.stubs(:free_agent_config).returns({})
    FreeAgent::Company.stubs(:new).returns(stub('company', :invoices => invoices))
  end
end