require 'spec_helper'
require 'orm_adapter/example_app_shared'

if !defined?(CouchRest::Model) || !(CouchRest.database!("http://admin:admin@127.0.0.1:5984/test") rescue nil)
  puts "** require 'couchrest_model' to run the specs in #{__FILE__}"
else  

  CouchRest.database!("http://admin:admin@127.0.0.1:5984/test")
  CouchRest::Model::Base.connection.update(:username => "admin", :password => "admin")
  CouchRest::Model::Base.use_database("test")
  
  module CouchRestOrmSpec
    class User < CouchRest::Model::Base
      property :name
      property :rating
      
      design do
        view :by_name
        view :by_rating
      end
    end

    class Note < CouchRest::Model::Base
      property :body, :default => "made by orm"
      belongs_to :owner, :class_name => 'CouchRestOrmSpec::User'
      
      design do
        view :by_name
      end
    end
    
    # here be the specs!
    describe CouchRest::Model::Base::OrmAdapter do
      before do
        User.delete_all
        Note.delete_all
      end
      it_should_behave_like "example app with orm_adapter" do
        let(:user_class) { User }
        let(:note_class) { Note }
      end
    end
  end
end