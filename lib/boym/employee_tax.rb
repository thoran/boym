module Boym
  class EmployeeTax

    attr_reader :employee

    def initialize(employee)
      @employee = employee
    end

    def tax_bracket
      Boym::TaxTable.applicable_tax_bracket(employee.annual_salary)
    end

    def monthly_tax_payable
      yearly_income = employee.annual_salary.to_i
      ((tax_bracket.base_amount + ((yearly_income - tax_bracket.income_range_start) * tax_bracket.rate))/12.0).round
    end
    alias_method :income_tax, :monthly_tax_payable

    def superannuation
      ((employee.annual_salary * employee.super_rate)/12.0).round
    end

    def gross_income
      (employee.annual_salary.to_i/12.0).round
    end

    def net_income
      gross_income - income_tax
    end

    def to_h
      {
        'name' => employee.name,
        'pay_period' => employee.pay_period,
        'gross_income' => gross_income,
        'income_tax' => income_tax,
        'net_income' => net_income,
        'super' => superannuation
      }
    end

  end
end
