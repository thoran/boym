# test/employee.rb

spec_dir = File.expand_path(File.join(__FILE__, '..'))
$LOAD_PATH.unshift(spec_dir) unless $LOAD_PATH.include?(spec_dir)

require 'spec_helper'
require 'employee'

describe "Employee" do

  subject{Employee.new(employee_data)}

  let(:first_name){'Larry'}
  let(:last_name){'Loser'}
  let(:annual_salary){'80000'}
  let(:super_rate){'5%'}
  let(:payment_start_date){'01 March 2015'}
  let(:employee_data) do
    {
      first_name: first_name,
      last_name: last_name,
      annual_salary: annual_salary,
      super_rate: super_rate,
      payment_start_date: payment_start_date
    }
  end

  describe "#initialize" do
    it "assigns first_name" do
      expect(subject.first_name).to eq(first_name)
    end

    it "assigns last_name" do
      expect(subject.last_name).to eq(last_name)
    end

    it "assigns and casts annual_salary" do
      expect(subject.annual_salary).to eq(annual_salary.to_i)
    end

    it "assigns, casts, and divides super_rate" do
      expect(subject.super_rate).to eq(super_rate.to_i/100.0)
    end

    it "assigns payment_start_date" do
      expect(subject.pay_period).to eq(payment_start_date)
    end
  end

  describe "#name" do
    it "combines first and last names" do
      expect(subject.name).to eq(first_name + ' ' + last_name)
    end
  end

end
