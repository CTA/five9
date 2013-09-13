module Five9
	module UserManagement
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

      def create_user user_info = {}
        validate_connection do
          response = @client.call :create_user, { message: {
            userInfo: user_info } }
          process_return_hash response, :create_user_response
        end
      end

      def delete_user username
        validate_connection do
          response = @client.call :delete_user, message: { user_name: username }
          process_return_hash response, :delete_user_response
        end
      end

      def get_users_general_info username_pattern = nil
        validate_connection do
          response = @client.call :get_users_general_info,
            message: { userNamePattern: username_pattern }
          process_return_hash response, :get_users_general_info_response
        end
      end

      def get_users_info username_pattern = nil
        validate_connection do
          response = @client.call :get_users_info,
            message: { userNamePattern: username_pattern }      
          process_return_hash response, :get_users_info_response
        end
      end

      def modify_user args
        validate_connection do
          response = @client.call :modify_user, message: args
          process_return_hash response, :modify_user_response
        end
      end

      def user_skill_add skill
        validate_connection do
          response = @client.call :user_skill_add, message: skill
          process_return_hash response, :user_skill_add_response
        end
      end

      def user_skill_modify skill
        validate_connection do
          response = @client.call :user_skill_modify, message: skill
          process_return_hash response, :user_skill_modify_response
        end
      end

      def user_skill_remove skill
        validate_connection do
          response = @client.call :user_skill_remove, message: skill
          process_return_hash response, :user_skill_remove_response
        end
      end

      def test_create_user
        create_user({ 
          # userInfo: {
            generalInfo: {
              canChangePassword: true,
              "EMail" => "superdave@ctatechs.com",
              firstName: "Dave",
              # fullName: "Dave Kent",
              lastName: "Kent",
              mustChangePassword: true,
              password: "Lemon$",
              startDate: Time.new,
              userName: "superdave@ctatechs.com",
              userProfileName: "Agent"
            },
            roles: {
              agent: {
                alwaysRecorded: true,
                attachVmToEmail: true,
              },
                sendEmailOnVm: true
            },
            skills: {
              level: "2",
              skillName: "IHS Skill Group",
              userName: "superdave@ctatechs.com"
            }
          # }
        })
      end

      def test_modify_user
        modify_user( # { 
            userGeneralInfo: {
              # canChangePassword: true,
              "EMail" => "superdave@ctatechs.com",
              # firstName: "Dave",
              # fullName: "David Kent",
              # lastName: "Kent",
              # mustChangePassword: true,
              # password: "Lemon$",
              # startDate: Time.new,
              userName: "superdave@ctatechs.com",
              # userProfileName: "Agent"
            # },
            # roles: {
            #   agent: {
            #     alwaysRecorded: true,
            #     attachVmToEmail: true,
            #   },
            #     sendEmailOnVm: true
            # },
            # skills: {
            #   level: "2",
            #   skillName: "IHS Skill Group",
            #   userName: "superdave@ctatechs.com"
            # }
          }
        )
      end

      private
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
    end
	end
end