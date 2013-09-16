module Five9
  class SkillArray
    attr_accessor :skills
    def initialize(args)
      @skills = []
      set_initial_skills(args)
      @old_skills = @skills
    end

    def to_a
      @skills
    end

    def add(skill)
      @skills << skill unless @skills.include? skill
    end

    def add!(skill=nil)
      add(skill) if skill
      (@skills - @old_skills).each do |new_skill|
        UserManagement.user_skill_add new_skill
        @old_skills << new_skill
      end
    end

    def remove(skill)
      @skills.delete(skill)
    end

    def remove!(skill=nil)
      remove(skill) if skill
      (@old_skills - @skills).each do |old_skill|
        UserManagement.user_skill_remove old_skill
        @old_skills.delete old_skill
      end
    end

    def update!
      add! ; remove!
    end

    def method_missing(method_name, *args)
      @skills.send(method_name, *args)
    end
    
    private
      def set_initial_skills(args)
        if args.class == Array
          args.each do |skill|
            @skills << skill.make_accessible
          end
        elsif args.class == NilClass
        else
          @skills << args.make_accessible
        end
      end
  end
end