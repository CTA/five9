module Five9
  class User
    attr_reader :general_info, :roles, :skills
    def initialize(args)
      @user_info = args.make_accessible
      @general_info = @user_info[:general_info].make_accessible
      @roles = @user_info[:roles].make_accessible
      @skills = SkillArray.new(args[:skills])
    end

    def to_h
      @user_info[:general_info] = @general_info
      @user_info[:roles] = @roles
      @user_info[:skills] = @skills.to_a
      @user_info
    end

    def save
      UserManagement.modify_user(build_modify_hash)
      @skills.update!
      self
    end

    def delete!
      UserManagement.delete_user user_name
    end

    def update(args)
      if args[:general_info]
        @user_info = to_h.merge(args)
        @general_info = @user_info[:general_info].make_accessible
        @roles = @user_info[:roles].make_accessible
        @skills = SkillArray.new(args[:skills])
        @user_info
      else
        merge! args
      end
    end

    def update!(args)
      update args
      save
    end

    def method_missing(method_name, *args)
      @general_info.send(method_name, *args)
    end

    def self.exist?(username)
      not UserManagement.get_users_info(username)[:general_info].nil?
    end

    def self.create!(args)
      new UserManagement.create_user(args)
    end

    def self.find(username)
      new(UserManagement.get_users_info(username)) if exist?(username)
    end

    def self.all
      UserManagement.get_users_info.map do |user_info|
        new(user_info)
      end
    end

    def self.where(args)
      all.keep_if do |user|
        user.merge(args).to_hash == user.to_hash
      end
    end

    private
      def build_modify_hash
        result = {}
        @general_info["EMail"] ||= @general_info.e_mail
        result[:userGeneralInfo] = @general_info.to_hash
        result
        # TODO configure rolesToSet and rolesToRemove
      end
  end
end