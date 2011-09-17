#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'bundler/setup'

class Harmonia
  autoload :Administrator, "harmonia/administrator"
  autoload :Mail, "harmonia/mail"

  def initialize(store_path)
    @administrator = Harmonia::Administrator.new(store_path)
  end

  def assign(task)
    assignee = @administrator.assign(task)
    dispatch_mail_for_task(task, assignee)
  end

  private

  def dispatch_mail_for_task(task, assignee)
    case task
    when :invoices
      Harmonia::Mail::Invoices.new(assignee).send
    when :weeknotes
      Harmonia::Mail::Weeknotes.new(assignee).send
    end
  end
end