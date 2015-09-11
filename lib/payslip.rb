class Payslip

  attr_accessor :employees_taxes, :payslip_filename

  def initialize(employees_taxes)
    @employees_taxes = employees_taxes
  end

  def <<(employee_tax)
    payslip_file.rows << employee_tax.to_h
  end

  def dump(payslip_filename)
    @payslip_filename = payslip_filename
    employees_taxes.each do |employee_tax|
      self << employee_tax
    end
    payslip_file.write
  end

  private

  def payslip_file
    @payslip_file ||= (
      csv_file = CSVFile.new(payslip_filename, headers: true, mode: 'w', quote: :none)
      csv_file.columns = [:name, :pay_period, :gross_income, :income_tax, :net_income, :super]
      csv_file
    )
  end

end
