require 'rubygems'
require 'epp-client'

#chriscow: Configure SSLContext for configuring certificate
cert = OpenSSL::X509::Certificate.new(File.read("YOUR_CERTIFICATE.crt"))
key = OpenSSL::PKey::RSA.new(File.read("YOUR_PRIVATE_KEY.key"))

store = OpenSSL::X509::Store.new
store.add_file 'YOUR_CERTIFICATE_CHAIN.crt'

ctx = OpenSSL::SSL::SSLContext.new
ctx.ssl_version = :TLSv1_2
ctx.cert = cert
ctx.key = key
ctx.cert_store = store

client = EPP::Client.new('USERNAME', 'PASSWORD', 'EPP.SERVER.ZONE', :ssl_context => ctx)

resp = client.info EPP::Domain::Info.new('example.com')
info = EPP::Domain::InfoResponse.new(resp)
info.name         #=> "example.com"
info.nameservers  #=> [{"name"=>"ns1.example.net"},{"name"=>"ns2.example.net"}]
