# spec/employee.rb

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

  describe "#superannuation" do
    it "returns the monthly amount" do
      expected_superannuation = ((subject.annual_salary * subject.super_rate)/12.0).round
      expect(subject.superannuation).to eq(expected_superannuation)
    end
  end

  describe "#gross_income" do
    it "returns the monthly amount" do
      expected_gross_income = (annual_salary.to_i/12.0).round
      expect(subject.gross_income).to eq(expected_gross_income)
    end
  end

  context "tax related" do

    let(:yearly_income){subject.annual_salary}
    let(:income_range_start){'37001'}
    let(:income_range_finish){'80000'}
    let(:base_amount){'3572'}
    let(:rate){'0.325'}
    let(:tax_bracket_data) do
      {
        income_range_start: income_range_start,
        income_range_finish: income_range_finish,
        base_amount: base_amount,
        rate: rate
      }
    end
    let(:gross_income){(subject.annual_salary.to_i/12.0).round}
    let(:income_tax) do
      ((base_amount.to_i + ((yearly_income - income_range_start.to_i) * rate.to_f))/12.0).round
    end

    before do
      allow(TaxTable).to receive(:applicable_tax_bracket).with(subject.annual_salary).and_return(TaxTable::TaxBracket.new(tax_bracket_data))
    end

    describe "#income_tax" do
      it "returns the monthly amount" do
        expected_income_tax = ((base_amount.to_i + ((yearly_income - income_range_start.to_i) * rate.to_f))/12.0).round
        expect(subject.income_tax).to eq(expected_income_tax)
      end
    end

    describe "#net_income" do

      it "returns the monthly amount" do
        expected_net_income = gross_income - income_tax
        expect(subject.net_income).to eq(expected_net_income)
      end
    end

    describe "#to_h" do
      let(:superannuation) do
        ((subject.annual_salary * subject.super_rate)/12.0).round
      end

      it "returns the expected hash" do
        expected_hash = {
          'name' => subject.name,
          'pay_period' => subject.pay_period,
          'gross_income' => gross_income,
          'income_tax' => income_tax,
          'net_income' => (gross_income - income_tax),
          'super' => superannuation
        }
        expect(subject.to_h).to eq(expected_hash)
      end
    end
  end
end
