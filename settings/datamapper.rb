# Be sure to comment/uncomment the respective dm-adatper gems in ./Gemfile

configure :development do

	# Shows DataMapper queries alongside page requests:
	DataMapper::Logger.new $stdout, :debug

	# Memory
	# DataMapper.setup :default, 'sqlite::memory:'

	# SQLite
	DataMapper.setup :default, "sqlite://#{Dir.pwd}/data/development.sqlite3"

	# MySQL
	# DataMapper.setup :default, 'mysql://username:password@host_url:3306/database_name'

	# PostreSQL
	# DataMapper.setup :default, 'postgres://username:password@host_url:5432/database_name'

end

configure :production do

	# Shows DataMapper queries alongside page requests:
	# DataMapper::Logger.new $stdout, :debug

	# Memory
	# DataMapper.setup :default, 'sqlite::memory:'

	# SQLite
	DataMapper.setup :default, "sqlite://#{Dir.pwd}/data/development.sqlite3"

	# MySQL
	# DataMapper.setup :default, 'mysql://username:password@host_url:3306/database_name'

	# PostgreSQL
	# DataMapper.setup :default, 'postgres://username:password@host_url:5432/database_name'

	# Heroku PostgreSQL
	# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

end