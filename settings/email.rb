# Email setup, see Pony docs for more info.

Pony.options = {
	via: :smtp,
	via_options: {
		address: '',
		port: '',
		domain: '',
		user_name: '',
		password: '',
		authentication: :plain,
		enable_starttls_auto: true
	}
}

# Heroku example:
#
# Pony.options = {
# 	via: :smtp,
# 	via_options: {
# 		address: 'smtp.sendgrid.net',
# 		port: '587',
# 		domain: 'heroku.com',
# 		user_name: ENV['SENDGRID_USERNAME'],
# 		password: ENV['SENDGRID_PASSWORD'],
# 		authentication: :plain,
# 		enable_starttls_auto: true
# 	}
# }