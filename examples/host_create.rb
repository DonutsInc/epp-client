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
command = EPP::Host::Create.new('ns1.example.com',
  ipv4: "198.51.100.53",
  ipv6: "2001:db8::53:1"
)

resp = client.create command
result = EPP::Host::CreateResponse.new(resp)
result.name           #=> "ns1.example.com"
result.creation_date  #=> 2014-11-27 11:15:04 +0000
