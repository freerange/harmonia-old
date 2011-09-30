require "test_helper"

class AdministratorTest < Test::Unit::TestCase
  def setup
    @administrator = Harmonia::Administrator.new(["Tom", "Dick", "Harry"], store_path)
    @administrator.reset!
  end

  def test_should_be_able_to_assign_someone_to_a_task
    person = @administrator.assign(:some_task)
    assert @administrator.people.include?(person)
    assert_equal person, @administrator.assignee(:some_task)
  end

  def test_should_store_and_reload_the_assigned_people
    task_a_person = @administrator.assign(:task_a)
    @other_harmonia = Harmonia::Administrator.new(["Tom", "Dick", "Harry"], store_path)
    assert_equal task_a_person, @other_harmonia.assignee(:task_a)
  end

  def test_should_reset_the_assignee_when_assigning_again
    person_1 = @administrator.assign(:task_a)
    person_2 = @administrator.assign(:task_a)
    assert_equal person_2, @administrator.assignee(:task_a)
  end

  def test_should_not_assign_the_same_person_to_two_tasks
    100.times do
      person_1 = @administrator.assign(:task_a)
      person_2 = @administrator.assign(:task_b)
      assert_not_equal person_1, person_2, "nobody should be assigned to two tasks"
    end
  end

  def test_should_assign_each_person_a_task_if_the_number_of_tasks_equals_the_number_of_people
    assigned = (1..@administrator.people.length).map do |x|
      @administrator.assign("task_#{x}")
    end
    assert_equal assigned.sort, @administrator.people.sort
  end

  def test_should_assign_to_the_same_person_if_more_tasks_than_people_have_been_assigned
    (@administrator.people.length + 1).times do |x|
      person = @administrator.assign("task_#{x}")
      assert @administrator.people.include?(person), "assignee #{person.inspect} isn't a person"
    end
  end

  def test_should_assign_to_the_people_with_fewer_tasks_if_more_tasks_than_people_have_been_assigned
    assignments = Hash.new(0)
    ((@administrator.people.length*2) - 1).times do |x|
      person = @administrator.assign("task_#{x}")
      assignments[person] += 1
    end
    max = assignments.values.max
    assignments.reject! { |person,count| count == max }
    person_with_less_tasks = assignments.keys.first
    assert_equal person_with_less_tasks, @administrator.assign(:another_task)
  end

  def test_should_allow_reselection_of_same_person_when_assigning_the_same_task
    same_person_assigned = (1..100).find do
      person_a = @administrator.assign(:task)
      person_b = @administrator.assign(:task)
      person_a == person_b
    end
    assert same_person_assigned
  end

  def test_should_be_able_to_unassign_a_person_to_make_them_available_again
    person = @administrator.assign(:task)
    (@administrator.people.length - 1).times do |x|
      assert_not_equal person, @administrator.assign("task_#{x}")
    end
    @administrator.unassign(:task)
    assert_equal person, @administrator.assign("another_task")
  end
end