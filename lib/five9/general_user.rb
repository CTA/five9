module Five9
  class GeneralUser
    def initialize(args)
      @user_general_info = args.make_accessible
    end

    def to_h
      @user_general_info
    end
    
    def save!
      if GeneralUser.exist? user_name
        UserManagement.modify_user(build_sendable_hash)[:general_info]
      else
        UserManagement.create! @user_general_info
      end
    end

    def delete!
      UserManagement.delete_user user_name
      @user_general_info
    end

    def update(args)
      merge! args
    end

    def update!(args)
      update(args)
      save!
    end

    def method_missing(method_name, *args)
      @user_general_info.send(method_name, *args)
    end

    def self.all
      UserManagement.get_users_general_info.map do |user_general_info|
        new(user_general_info)
      end
    end

    def self.create!(args)
      new(UserManagement.create_user(build_sendable_hash(args))[:general_info])
    end

    def self.exist?(username)
      not find(username).nil?
    end

    def self.find(username)
      general_user = new(UserManagement.get_users_general_info(username))
      if general_user[:user_name]
        general_user
      else
        nil
      end
    end

    def self.where(args)
      all.keep_if do |general_user|
        general_user.merge(args).to_hash == general_user.to_hash
      end
    end

    private
      def build_sendable_hash
        result = {}
        result[:userGeneralInfo] = @user_general_info
        result[:userGeneralInfo]["EMail"] = 
          @user_general_info[:e_mail] || @user_general_info["EMail"]
        result
      end

      def self.build_sendable_hash(user_general_info)
        result = {}
        user_general_info["EMail"] ||= user_general_info[:e_mail]
        user_general_info[:can_change_password] = true
        result[:generalInfo] = user_general_info
        result[:roles] = {agent: {}}
        result
      end
  end
end