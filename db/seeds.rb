# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Please change this user email and password before using
User.create!(:name => 'administrator', :email => 'administrator@administrator.com', :password => 'administrator', :admin => true)