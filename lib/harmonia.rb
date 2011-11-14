#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'bundler/setup'

class Harmonia
  autoload :Administrator, "harmonia/administrator"
  autoload :Mail, "harmonia/mail"

  def initialize(store_path=File.expand_path("../../config/assignments.yml", __FILE__))
    people = ["James A", "James M", "Tom", "Jase", "Chris"]
    @administrator = Harmonia::Administrator.new(people, store_path)
  end

  def assign(task)
    assignee = @administrator.assign(task)
    dispatch_mail_for_task(task, assignee)
  end

  def remind(task)
    assignee = @administrator.assignee(task)
    dispatch_reminder_mail_for_task(task, assignee)
  end

  def unassign(task)
    @administrator.unassign(task)
  end

  private

  def dispatch_mail_for_task(task, assignee)
    case task
    when :invoices
      Harmonia::Mail::Invoices.new(assignee).send
    when :weeknotes
      Harmonia::Mail::Weeknotes.new(assignee).send
    else
      raise "Task #{task} isn't known to harmonia"
    end
  end

  def dispatch_reminder_mail_for_task(task, assignee)
    case task
    when :weeknotes
      Harmonia::Mail::Weeknotes.new(assignee).send_reminder
    end
  end
end