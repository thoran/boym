class TaxTable

  class TaxBracket

    attr_reader :income_range_start, :income_range_finish, :base_amount, :rate

    def initialize(tax_bracket_data)
      @income_range_start = (tax_bracket_data['income_range_start'] || tax_bracket_data[:income_range_start]).to_i
      @income_range_finish = (tax_bracket_data['income_range_finish'] || tax_bracket_data[:income_range_finish]).to_i
      @base_amount = (tax_bracket_data['base_amount'] || tax_bracket_data[:base_amount]).to_i
      @rate = (tax_bracket_data['rate'] || tax_bracket_data[:rate]).to_f
    end

    def monthly_tax_payable(yearly_income)
      yearly_income = yearly_income.to_i
      ((base_amount + ((yearly_income - income_range_start) * rate))/12.0).round
    end

    # boolean methods

    def applicable_bracket?(yearly_income)
      yearly_income = yearly_income.to_i
      if income_range_finish == 'infinity'
        income_range_start <= yearly_income
      else
        (income_range_start..income_range_finish).include?(yearly_income)
      end
    end

  end # class TaxBracket

  @tax_brackets = []

  class << self

    def tax_brackets
      @tax_brackets
    end

    def load(tax_table_file)
      tax_table_data = SimpleCSV.open(tax_table_file, headers: true)
      tax_table_data.each do |tax_bracket_data|
        tax_brackets << TaxBracket.new(tax_bracket_data)
      end
    end

    def applicable_tax_bracket(yearly_income)
      tax_brackets.detect{|tax_bracket| tax_bracket.applicable_bracket?(yearly_income)}
    end

    def monthly_tax_payable(yearly_income)
      applicable_tax_bracket(yearly_income).monthly_tax_payable(yearly_income)
    end

  end # class << self

  # Alternate implementations include:

  # 1. Using Ruby's Singleton module

  # require 'singleton'
  # include Singleton

  # def initialize(tax_table_data)
  #   tax_table_data.each do |tax_bracket_data|
  #     @tax_brackets << TaxBracket.new(tax_bracket_data)
  #   end
  # end

  # def applicable_tax_bracket
  #   @tax_brackets.detect{|tax_bracket| tax_bracket.applicable_bracket?(yearly_income)}
  # end

  # def monthly_tax_payable(yearly_income)
  #   applicable_tax_bracket.monthly_tax_payable(yearly_income)
  # end

  # 2. Using module_functions

  # module_function (using the class methods above), since the namespaced TaxBracket class will still work as before.

end
