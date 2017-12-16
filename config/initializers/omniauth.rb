OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '21476288076-p1804q3mrjbuc85gvmm94ekk1jn0ius1.apps.googleusercontent.com', 'CqF_PMGT96i26J-MEZRRPkAk', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end