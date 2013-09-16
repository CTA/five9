module Five9
  module ProfileManagement
    class << self
      def establish_connection adminuser, password
        @client = Base.new(adminuser, password,
          "https://api.five9.com/wsadmin/v2/AdminWebService?wsdl&user=")
            .instance_variable_get :@client
        @connected = true
      end

      def connected?
        @connected
      end

      def create_user_profile args
        validate_connection do
          response = @client.call :create_user_profile,
            message: { userProfile: args }
          process_return_hash response, :create_user_profile_response
        end
      end

      def get_user_profile profile_name
        validate_connection do
          response = @client.call :get_user_profiles,
            message: { userProfileName: profile_name }
          process_return_hash response, :get_user_profiles_response
        end
      end

      def get_user_profiles profile_name = nil
        validate_connection do
          response = @client.call :get_user_profiles,
            message: { userProfileNamePattern: profile_name }
          process_return_hash response, :get_user_profiles_response
        end
      end

      def delete_user_profile profile_name
        validate_connection do
           response = @client.call :delete_user_profile,
              message: { userProfileName: profile_name }
          process_return_hash response, :delete_user_profile_response
        end
      end

      def modify_user_profile profile_info
        validate_connection do
          response = @client.call :modify_user_profile,
            message: { userProfile: profile_info }
          process_return_hash response, :modify_user_profile_response
        end
      end

      def modify_user_profile_skills profile_name, skills_to_add=nil, skills_to_remove=nil
        validate_connection do
          response = @client.call :modify_user_profile_skills,
            message: { userProfileName: profile_name,
            addSkills: skills_to_add, removeSkills: skills_to_remove }
          process_return_hash response, :modify_user_profile_skills_response
        end
      end

      def modify_user_profile_user_list profile_name, users_to_add=nil, users_to_remove=nil
        validate_connection do
          response = @client.call :modify_user_profile_user_list,
            message: { userProfileName: profile_name,
            addUsers: users_to_add, removeUsers: users_to_remove }
          process_return_hash response, :modify_user_profile_user_list_response
        end
      end

      private
        def validate_connection &block
          if @connected
            begin
              block.call if block
            rescue Wasabi::Resolver::HTTPError
              raise "Something went wrong! Please insure the connection is established with the proper credentials."
            end
          else
            raise "Connection to Five9 not established!"
          end
        end

        def process_return_hash response, method_response_key
          response_hash = response.to_hash
          if response_hash[method_response_key].class == Hash
            unless response_hash[method_response_key][:return].class == NilClass
              return response_hash[method_response_key][:return]
            else
              return response_hash[method_response_key]
            end
          else
            return response_hash
          end
        end
    end
  end
end
