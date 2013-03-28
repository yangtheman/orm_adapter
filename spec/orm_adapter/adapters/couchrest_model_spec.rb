require 'spec_helper'
require 'orm_adapter/example_app_shared'

if !defined?(CouchRest::Model)
  puts "** require 'couchrest_model' to run the specs in #{__FILE__}"
else  
  
  CouchRest::Model::Base.use_database("http://localhost:5984/test")
  
  module CouchRestOrmSpec
    class User
      include CouchRest::Model
      field :name
      field :rating
    end

    class Note
      include CouchRest::Model
      field :body, :default => "made by orm"
      belongs_to :owner, :class_name => 'CouchRestOrmSpec::User'
    end
    
    # here be the specs!
    describe CouchRest::Model::OrmAdapter do
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