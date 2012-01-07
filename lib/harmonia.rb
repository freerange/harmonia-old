#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'bundler/setup'
require 'harmonia/freeagent_timeline'

class Harmonia
  autoload :Administrator, "harmonia/administrator"
  autoload :Mail, "harmonia/mail"
  autoload :Assignments, "harmonia/assignments"

  def initialize(store_path=File.expand_path("../../config/assignments.yml", __FILE__))
    people = ["James A", "James M", "Tom", "Jase", "Chris"]
    @administrator = Harmonia::Administrator.new(people, Harmonia::Assignments.new(store_path))
  end

  def assign(task)
    if task_required?(task)
      assignee = @administrator.assign(task)
      dispatch_mail_for_task(task, assignee)
    end
  end

  def remind(task)
    assignee = @administrator.assignee(task)
    dispatch_reminder_mail_for_task(task, assignee)
  end

  def unassign(task)
    @administrator.unassign(task)
  end

  private

  def task_required?(task)
    case task
    when :vat_return
      Harmonia::Mail::VatReturn.required?
    when :annual_return
      Harmonia::Mail::AnnualReturn.required?
    when :corporation_tax_payment
      Harmonia::Mail::CorporationTaxPayment.required?
    when :corporation_tax_submission
      Harmonia::Mail::CorporationTaxSubmission.required?
    else
      true
    end
  end

  def dispatch_mail_for_task(task, assignee)
    Harmonia::Mail.build(task, assignee).send
  rescue NameError => e
    if e.is_a?(NoMethodError)
      raise e
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