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

command = EPP::Domain::Create.new('example.com',
  period: '1y', registrant: 'test9023742684',
  auth_info: { pw: 'domainpassword' },
  contacts: { admin: 'admin123', tech: 'admin123', billing: 'admin123' },
  nameservers: [
    {name: 'ns1.example.com', ipv4: '198.51.100.53'}
    {name: 'ns2.example.com', ipv4: '198.51.100.54'}
  ]
)

resp = client.create command
result = EPP::Domain::CreateResponse.new(resp)
result.name             #=> "example.com"
result.expiration_date  #=> 2014-11-27 11:15:04 +0000
