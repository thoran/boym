module Boym
  class Employee

    class << self

      def all(filename)
        load(filename).collect{|employee_data| new(employee_data)}
      end

      def load(filename)
        SimpleCSV.open(filename, headers: true)
      end

    end # class << self

    include ActiveModel::Validations

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :annual_salary, presence: true
    validates :annual_salary, format: /\d+/
    validates :super_rate, presence: true
    validates :super_rate, format: /\d{1,2}\%/
    validates :payment_start_date, presence: true
    validates :payment_start_date, format: /\d\d \S+ – \d\d \S+/

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

  end
end
