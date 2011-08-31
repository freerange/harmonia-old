ENV["ENV"] = "test"
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "harmonia"
require "test/unit"
require "mocha"