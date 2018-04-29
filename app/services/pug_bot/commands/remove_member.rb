module PugBot
  module Commands
    class RemoveMember

      include PugBot::Arguments

      def initialize(event, bot)
        @event = event
        @bot = bot
        
        if arguments[1] == "all"
          @all = true
        end
      end

      def process
        return disallowed if not_allowed?

        return destroy_all if all

        return missing_arguments if missing_arguments?

        pug = Pug.where(pug_type: pug_type, region: region).first

        if pug
          pug_member = pug.pug_members.where(discord_tag: discord_tag).first

          if pug_member
            pug_member.destroy

            "You have removed #{discord_tag} from #{region} #{pug_type}."
          else
            "That member is not part of the #{region} #{pug_type}"
          end
        else
          "There's no pug for that region/level, and thus no member for that PUG. Get it together."
        end
      end

      private

      attr_accessor :event, :bot, :all

      def discord_tag
        arguments[0]
      end

      def region
        arguments[1].upcase
      end

      def pug_type
        arguments[2].downcase
      end

      def destroy_all
        PugMember.where(discord_tag: discord_tag).destroy_all
        all_removed
      end

      def all_removed
        "All of this user's registrations have been removed."
      end

      def missing_arguments
        "You're missing a bunch of info. Check ?help for the proper format."
      end

      def missing_arguments?
        return false if all
        arguments.length < 3
      end

      def role_ids
        [
          421795021508050955,
          352683399812481026,
          352683696161030167,
        ]
      end

      def user_roles
        event.user.roles.map(&:id)
      end

      def not_allowed?
        (role_ids & user_roles).empty?
      end

      def disallowed
        "Yeaaahhh... this is awkward. You're not allowed to do that. Come back when you're cooler!"
      end
    end
  end
end
