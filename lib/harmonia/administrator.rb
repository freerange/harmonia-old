require 'yaml'

class Harmonia
  class Administrator
    attr_reader :people

    def initialize(people, assignments)
      @people = people
      @assignments = assignments
    end

    def unassign_all
      @assignments.unassign_all
    end

    def assign(task)
      person = random_available_person_for(task)
      @assignments.assign(task, person)
      assignee(task)
    end

    def assignee(task)
      @assignments.assigned_to(task)
    end

    def unassign(task)
      @assignments.unassign(task)
    end

    private

    def random_available_person_for(task)
      task_counts = @people.inject({}) do |h, person|
        h[person] = assigned_tasks_ignoring(task, person).count
        h
      end

      @people.select { |person| task_counts[person] == task_counts.values.min }.shuffle.first
    end

    def assigned_tasks_ignoring(task, person)
      @assignments.tasks_assigned_to(person) - [task]
    end
  end
end