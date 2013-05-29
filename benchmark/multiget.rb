require 'benchmark'
require 'yaml'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'riak'
# require 'riak/test_server'

count = 500

# config = YAML.load_file(File.expand_path("../../spec/support/test_server.yml", __FILE__))

cluster = (1..4).map do |n|
  {host: '127.0.0.1', pb_port: "100#{n}7", http_port: "100#{n}8" }
end

client = Riak::Client.new nodes: cluster

bucket = client.bucket 'mooltiget'

keys = (0..count).map(&:to_s)

# puts "Inserting #{count} key value pairs"
# 
# keys.each do |n|
#   if n % 100 == 0
#     print "\r#{n}"
#   end
#   obj = bucket.get_or_new n.to_s
#   obj.content_type = 'text/plain'
#   obj.data = n.to_s
#   obj.store
# end

# puts "waiting"

# sleep 10

puts "benchmarking"

Benchmark.bmbm do |x|
  x.report 'individual' do
    keys.each {|k| bucket[k]}
  end

  x.report 'multiget' do
    bucket.get_many keys
  end
end

# puts "deleting #{count} key value pairs"

# keys.each do |k|
#   bucket.delete k
# end
