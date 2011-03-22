module Hector
  module Concerns
    module Authentication
      def on_user
        @username = request.args.first
        @realname = request.text
        authenticate
      end

      def on_pass
        @password = request.text
        authenticate
      end

      def on_nick
        @nickname = request.text
        authenticate
      end

      protected
        def authenticate
          set_identity
          set_session
        end

        def set_identity
          if (@username && !@identity)
            if (!Identity.auth_required?(request))
              @identity = Identity.new(@username)
            elsif (@password)
              Identity.authenticate(@username, @password) do |identity|
                if @identity = identity
                  set_session
                else
                  error InvalidPassword
                end
              end
            end
          end
        end

        def set_session
          if @identity && @nickname
            @session = UserSession.create(@nickname, self, @identity, @realname)
          end
        end
    end
  end
end
