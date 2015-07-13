require_relative 'tax_table'

class Employee

  attr_accessor :first_name, :last_name, :annual_salary, :super_rate, :pay_period

  def initialize(employee_data)
    @first_name = employee_data['first_name'] || employee_data[:first_name]
    @last_name = employee_data['last_name'] || employee_data[:last_name]
    @annual_salary = (employee_data['annual_salary'] || employee_data[:annual_salary]).to_i
    @super_rate = (employee_data['super_rate'] || employee_data[:super_rate]).to_i/100.0
    @pay_period = employee_data['payment_start_date'] || employee_data[:payment_start_date]
  end

  def name
    first_name + ' ' + last_name
  end

  def superannuation
    ((annual_salary * super_rate)/12.0).round
  end

  def gross_income
    (annual_salary.to_i/12.0).round
  end

  def income_tax
    TaxTable.monthly_tax_payable(annual_salary)
  end

  def net_income
    gross_income - income_tax
  end

  def to_h
    {
      'name' => name,
      'pay_period' => pay_period,
      'gross_income' => gross_income,
      'income_tax' => income_tax,
      'net_income' => net_income,
      'super' => superannuation
    }
  end

end
