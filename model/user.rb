module KamiParty
  class User < Sequel::Model
    set_schema do
      primary_key :id

      # auth
      varchar :login, :unique => true
      varchar :pass

      # roles
      boolean :is_admin, :default => false

      # meta
      varchar :name
    end

    create_table unless table_exists?

    if count == 0
      create :login => 'manveru',
        :name => 'Michael Fellinger',
        :pass => 'letmein',
        :is_admin => true
    end
  end
end
