OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '233397126840128', 'd3af22ebf5c772a4a73f5e11ae34075d', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
  provider :twitter, 'h3MjTQXa0SzsXwwGEPi9g', 'cg9ChK5UZk7XnbE6DyCpkTjnUCClVljuPMKp4cutMs', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
  provider :gplus, '143973953539-7eq393li4e83f4gso0tmjmvj890bke74.apps.googleusercontent.com', 'KhussdwFBWx_tArkFLNruxuc', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end