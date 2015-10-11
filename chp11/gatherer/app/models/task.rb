class Task < ActiveRecord::Base
  belongs_to :project

  def mark_completed(date = nil)
    self.completed_at = date || Time.current
  end

  def complete?
    completed_at.present?
  end

  def part_of_velocity?
    return false unless complete?
    completed_at > Project.velocity_length_in_days.days.ago
  end

  def points_toward_velocity
    if part_of_velocity? then size else 0 end
  end

  def small?
    size <= 1
  end

  def epic?
    size >= 5
  end

  def first_in_project?
    return false unless project
    project.tasks.first == self
  end

  def last_in_project?
    return false unless project
    project.tasks.last == self
  end

  def my_place_in_project
    project.tasks.index(self)
  end

  def previous_task
    project.tasks[my_place_in_project - 1]
  end

  def next_task
    project.tasks[my_place_in_project + 1]
  end

  def swap_order_with(other)
    self.project_order, other.project_order =
      other.project_order, self.project_order
    self.save
    other.save
  end

  def move_up
    swap_order_with(previous_task)
  end

  def move_down
    swap_order_with(next_task)
  end
end
