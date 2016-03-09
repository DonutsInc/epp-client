require 'rubygems'
require 'epp-client'

cert = OpenSSL::X509::Certificate.new(File.read("YOUR_CERTIFICATE.crt"))
key = OpenSSL::PKey::RSA.new(File.read("YOUR_PRIVATE_KEY.key"))

store = OpenSSL::X509::Store.new
store.add_file 'YOUR_CERTIFICATE_CHAIN.crt'

# Configure SSLContext with complete client certificate chain
ctx = OpenSSL::SSL::SSLContext.new
ctx.ssl_version = :TLSv1_2
ctx.cert = cert
ctx.key = key
ctx.cert_store = store

client = EPP::Client.new('USERNAME', 'PASSWORD', 'EPP.SERVER.ZONE', :ssl_context => ctx)


resp  = client.check EPP::Domain::Check.new('paincave.bike', 'paincave.net', 'available-123-abc.bike')
check = EPP::Domain::CheckResponse.new(resp)

puts check.available?('paincave.bike') #=> true
puts check.available?('paincave.net') #=> false
puts check.available?('available-123-abc.bike') #=> true
