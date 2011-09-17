require 'yaml'

class Harmonia
  class Administrator
    attr_accessor :people

    def initialize(store_path="config/assignments.yml", people_path="config/people.yml")
      @people = YAML.load_file(people_path) rescue []
      @store_path = store_path
      @assigned = YAML.load_file(store_path) rescue {}
    end

    def reset!
      @assigned = {}
      write_store
    end

    def assign(task)
      @assigned[task] = random_available_person_for(task)
      write_store
      assignee(task)
    end

    def assignee(task)
      @assigned[task]
    end

    def unassign(task)
      @assigned.delete(:task)
      write_store
    end

    private

    def write_store
      File.open(@store_path, "w") { |f| f.write @assigned.to_yaml }
    end

    def random_available_person_for(task)
      remaining_candidates = @people - @assigned.reject { |t,_| t == task }.values
      if remaining_candidates.empty?
        task_count = @assigned.values.inject({}) do |h, person|
          h[person] ||= 0
          h[person] += 1
          h
        end
        remaining_candidates = task_count.reject { |person, count| count == task_count.values.max }.keys
        remaining_candidates = @people if remaining_candidates.empty?
      end
      remaining_candidates[rand(remaining_candidates.length)]
    end
  end
end