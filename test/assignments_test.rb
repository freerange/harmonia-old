require "test_helper"

class AssignmentsGivenNonExistentYamlFile < Test::Unit::TestCase
  def setup
    FileUtils.rm(store_path) if File.exist?(store_path)
    @assignments = Harmonia::Assignments.new(store_path)
  end

  def test_should_return_an_empty_list_of_people
    assert_equal [], @assignments.people
  end

  def test_should_return_an_empty_list_of_tasks
    assert_equal [], @assignments.tasks
  end
end

class AssignmentsGivenEmptyYamlFile < Test::Unit::TestCase
  def setup
    File.open(store_path, "w") { |file| file.write("") }
    @assignments = Harmonia::Assignments.new(store_path)
  end

  def test_should_return_an_empty_list_of_people
    assert_equal [], @assignments.people
  end

  def test_should_return_an_empty_list_of_tasks
    assert_equal [], @assignments.tasks
  end
end

class AssignmentsWithNoneExistingTest < Test::Unit::TestCase
  def setup
    File.open(store_path, "w") { |file| file.puts({}.to_yaml) }
    @assignments = Harmonia::Assignments.new(store_path)
  end

  def test_should_return_an_empty_list_of_people
    assert_equal [], @assignments.people
  end

  def test_should_return_an_empty_list_of_tasks
    assert_equal [], @assignments.tasks
  end

  def test_should_allow_assigning_a_new_person_to_a_new_task
    @assignments.assign(:payroll, "James M")
    assert_equal "James M", @assignments.assigned_to(:payroll)
  end

  def test_should_ignore_removal_of_non_existent_assignment
    @assignments.unassign(:not_existing_task)
    assert_equal [], @assignments.people
    assert_equal [], @assignments.tasks
  end

  def test_should_return_an_empty_set_when_asking_for_the_tasks_assigned_to_a_person
    assert_equal [], @assignments.tasks_assigned_to("James A")
  end
end

class AssignmentsGivenExistingYamlFile < Test::Unit::TestCase
  def setup
    task_assignments = {
      invoices: "Chris",
      weeknotes: "Tom"
    }
    File.open(store_path, "w") { |file| file.puts(task_assignments.to_yaml) }
    @assignments = Harmonia::Assignments.new(store_path)
  end

  def test_should_return_the_list_of_people
    assert_equal ["Chris", "Tom"], @assignments.people
  end

  def test_should_return_the_list_of_tasks
    assert_equal [:invoices, :weeknotes], @assignments.tasks
  end

  def test_should_return_the_current_person_assigned_to_a_task
    assert_equal "Chris", @assignments.assigned_to(:invoices)
    assert_equal "Tom", @assignments.assigned_to(:weeknotes)
  end

  def test_should_return_the_set_of_tasks_when_asking_for_the_tasks_assigned_to_a_person
    assert_equal [:invoices], @assignments.tasks_assigned_to("Chris")
    assert_equal [:weeknotes], @assignments.tasks_assigned_to("Tom")
  end
end

class AssignmentsPreservingState < Test::Unit::TestCase
  def setup
    task_assignments = {
      weeknotes: "Tom"
    }
    File.open(store_path, "w") { |file| file.puts(task_assignments.to_yaml) }
    @assignments = Harmonia::Assignments.new(store_path)
  end

  def test_should_preserve_assignments
    @assignments.assign(:payroll, "James A")
    reloaded_assignments = Harmonia::Assignments.new(store_path)
    assert_equal "James A", reloaded_assignments.assigned_to(:payroll)
  end

  def test_should_preserve_unassignments
    @assignments.unassign(:weeknotes)
    reloaded_assignments = Harmonia::Assignments.new(store_path)
    assert_equal [], reloaded_assignments.tasks_assigned_to("Tom")
  end

  def test_should_preserve_unassigning_all_assignments
    @assignments.unassign_all
    reloaded_assignments = Harmonia::Assignments.new(store_path)
    assert_equal [], reloaded_assignments.people
    assert_equal [], reloaded_assignments.tasks
  end
end

class AssignmentsTest < Test::Unit::TestCase
  def setup
    File.open(store_path, "w") { |file| file.puts({}.to_yaml) }
    @assignments = Harmonia::Assignments.new(store_path)
    @assignments.assign(:invoices, "Chris")
    @assignments.assign(:weeknotes, "Tom")
  end

  def test_should_return_the_list_of_people
    assert_equal ["Chris", "Tom"], @assignments.people
  end

  def test_should_return_the_list_of_tasks
    assert_equal [:invoices, :weeknotes], @assignments.tasks
  end

  def test_should_return_the_current_person_assigned_to_a_task
    assert_equal "Chris", @assignments.assigned_to(:invoices)
  end

  def test_should_return_the_set_of_tasks_when_asking_for_the_tasks_assigned_to_a_person
    assert_equal [:invoices], @assignments.tasks_assigned_to("Chris")
  end

  def test_should_allow_a_new_person_to_be_assigned_to_an_existing_task
    @assignments.assign(:invoices, "James A")
    assert_equal "James A", @assignments.assigned_to(:invoices)
    assert_equal [:invoices], @assignments.tasks_assigned_to("James A")
  end

  def test_should_allow_a_new_person_to_be_assigned_to_a_new_task
    @assignments.assign(:vat_return, "Jase")
    assert_equal "Jase", @assignments.assigned_to(:vat_return)
    assert_equal [:vat_return], @assignments.tasks_assigned_to("Jase")
  end

  def test_should_allow_the_removal_of_an_assignment
    @assignments.unassign(:invoices)
    assert_equal ["Tom"], @assignments.people
    assert_equal [:weeknotes], @assignments.tasks
  end

  def test_should_allow_all_assignments_to_be_cleared
    @assignments.unassign_all
    assert_equal [], @assignments.people
    assert_equal [], @assignments.tasks
  end
end

class AssignmentsWithOnePersonAssignedToManyTasks < Test::Unit::TestCase
  def setup
    File.open(store_path, "w") { |file| file.puts({}.to_yaml) }
    @assignments = Harmonia::Assignments.new(store_path)
    @assignments.assign(:cleaning, "Chris")
    @assignments.assign(:recycling, "Chris")
  end

  def test_should_return_the_list_of_people
    assert_equal ["Chris"], @assignments.people
  end

  def test_should_return_the_list_of_tasks
    assert_equal [:cleaning, :recycling], @assignments.tasks
  end

  def test_should_return_the_current_person_assigned_to_a_task
    assert_equal "Chris", @assignments.assigned_to(:cleaning)
    assert_equal "Chris", @assignments.assigned_to(:recycling)
  end

  def test_should_return_the_set_of_tasks_when_asking_for_the_tasks_assigned_to_a_person
    assert_equal [:cleaning, :recycling], @assignments.tasks_assigned_to("Chris")
  end
end