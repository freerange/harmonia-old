require "yaml"

class Harmonia
  class Assignments
    def initialize(path)
      @assignments_path = path
      @assignments = if File.exist?(@assignments_path)
        YAML.load_file(path)
      else
        {}
      end
      @assignments = {} unless @assignments.is_a?(Hash)
    end

    def people
      @assignments.values.uniq
    end

    def tasks
      @assignments.keys
    end

    def assigned_to(task)
      @assignments[task]
    end

    def assign(task, person)
      @assignments[task] = person
      store_assignments
    end

    def unassign(task)
      @assignments.delete(task)
      store_assignments
    end

    def unassign_all
      @assignments = {}
      store_assignments
    end

    def tasks_assigned_to(person)
      @assignments.select { |task, assigned| assigned == person }.keys
    end

    private

    def store_assignments
      File.open(@assignments_path, "w") { |file| file.puts(@assignments.to_yaml) }
    end
  end
end