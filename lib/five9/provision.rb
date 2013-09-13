module Five9
	class Provision < Base
    # This class is essentially a cut-paste of the User Management methods
    # from the Five9 API. Arguments to the methods should be hashes of the
    # data values required in the API, unless otherwise specified.

		def initialize(adminuser, password)
      # arguments should be strings
			super(adminuser, password,
				"https://api.five9.com/wsadmin/v2/AdminWebService?wsdl&user=")
		end

		def create_user(args = {})
      # Use this method to create a user. 
      # An exception is thrown if the user already exists, if the limit number of users is reached, or if user attributes are invalid.
      begin
        @client.call :create_user, message: args
      rescue => error
        puts error.to_s.inspect
        return false
      end
		end

    def delete_user(username)
      # Use this method to delete the specified user. 
      # An exception is thrown if the user does not exist.
      # username is a string
      begin
        @client.call :delete_user, message: { user_name: username }
      rescue => error
        puts error.to_s.inspect
        return false
      end
    end

    def get_users_general_info(username_pattern = nil)
      # Use this method to obtain general information about each user name that matches a pattern.
        # username_pattern should be a regular expression.
        # If omitted or equal to an empty string, all objects are returned.
        # For example, a pattern may be the first characters of the user name.
      # Returns a hash or an array of hashes for multiple results
      begin
        response = @client.call :get_users_general_info, message: { userNamePattern: username_pattern }
        return response.to_hash[:get_users_general_info_response][:return]
      rescue => error
        puts error.to_s.inspect
        return false
      end
    end

    def get_users_info(username_pattern = nil)
      # Use this method to obtain information about roles and skills 
      # in addition to general information for the user, 
      # for each user name that matches a pattern.
      # username_pattern should be a regular expression
      begin
        response = @client.call :get_users_info, message: { userNamePattern: username_pattern }      
        return response.to_hash[:get_users_info_response][:return]
      rescue => error
        puts error.to_s.inspect
        return false
      end
    end

    def modify_user(args = {})
      # Use this method to modify user attributes
      # args may include userGeneralInfo, rolesToSet, and rolesToRemove
      begin
        @client.call :modify_user, message: args
      rescue => error
        puts error.to_s.inspect
        return false
      end
    end

    def modify_user_canned_reports(args = {})
      # Use this method to modify the list of canned reports associated with a specific user.
      # args may incldue user, cannedReportsToAdd, and cannedReportsToRemove
      begin
        @client.call :modify_user_canned_reports, message: args
      rescue => error
        puts error.to_s.inspect
        return false
      end
    end

    def add_user_skill(user_skill)
      # user_skill is a userSkill hash 
      affect_user_skill(:user_skill_add, user_skill)
    end

    def modify_user_skill(user_skill)
      # user_skill is a userSkill hash 
      affect_user_skill(:user_skill_modify, user_skill)
    end

    def remove_user_skill(user_skill)
      # user_skill is a userSkill hash 
      affect_user_skill(:user_skill_remove, user_skill)
    end

    private

      def affect_user_skill(affect, user_skill)
        begin
          @client.call affect, message: { userSkill: user_skill }
        rescue => error
          puts error.to_s.inspect
          return false
        end
      end
	end
end