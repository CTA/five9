module Five9
  class Profile
    attr_reader :attributes
    def initialize(args)
      @attributes = AccessibleHash.new(args)
    end

    def save
      ProfileManagement.modify_user_profile(self.to_h)
    end
    alias_method :update!, :save

    def method_missing(method_name, *args)
      @attributes.send(method_name, *args)
    end

    def self.create!(args)
      self.new(ProfileManagement.create_user_profile(args))
    end

    def self.find(profile_name)
      self.new(matching_profile(all, profile_name))
    end

    def self.all
      ProfileManagement.get_user_profiles.map do |profile_info|
        self.new(profile_info)
      end
    end

    private
      def self.matching_profile(all_profiles, profile_name)
        matching_profile = all_profiles.select do |profile|
          profile[:name] == profile_name
        end
        raise "No matching profiles were found!" if matching_profile.first.nil?
        matching_profile.first
      end
  end
end
