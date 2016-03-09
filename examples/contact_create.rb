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

command = EPP::Contact::Create.new('admin123',
  postal_info: {
    name: 'Test User',
    org: 'Test Organisation',
    addr: {
      street: "Test Building\n14 Test Road",
      city: "Test City",
      sp: "Test Province",
      pc: "TE57 1NG",
      cc: "GB"
    }
  },
  voice: '+44.1614960000',
  fax: '+44.1614960001',
  email: 'user@test.host',
  auth_info: { pw: '324723984' },
  disclose: { "0" => %w(voice email)}
)

resp = client.create command
result = EPP::Contact::CreateResponse.new(resp)
result.id             #=> "admin123"
result.creation_date  #=> 2014-11-27 11:15:04 +0000
