require 'rails_helper'

RSpec.describe "merchant bulk discounts index page" do
  describe "when I visit my bulk discounts index page" do
    before(:each) do
      @merch_1 = create(:merchant)
      @merch_2 = create(:merchant)
      @bulk_discount_1 = @merch_1.bulk_discounts.create!(percent_discount: 15, quantity_threshold: 10)
      @bulk_discount_2 = @merch_1.bulk_discounts.create!(percent_discount: 25, quantity_threshold: 2)
      @bulk_discount_3 = @merch_2.bulk_discounts.create!(percent_discount: 10, quantity_threshold: 5)
    end
  
    it "displays all of my bulk discounts and the bulk discount attributes" do
      visit merchant_bulk_discounts_path(@merch_1)
     
      within("#discount-deets-#{@bulk_discount_1.id}")do

        expect(page).to have_content("This discount gives 15.0% off when you buy 10.")
        expect(page).to_not have_content("This discount gives 25.0% off when you buy 2.")
        expect(page).to_not have_content("This discount gives 10.0% off")
      end

      within("#discount-deets-#{@bulk_discount_2.id}") do

        expect(page).to have_content("This discount gives 25.0% off when you buy 2.")
        expect(page).to_not have_content("This discount gives 15.0% off when you buy 10.")
        expect(page).to_not have_content("when you buy 5.")
      end
    end

    it 'displays a link to create a new discount and then redirects to new page with form' do
      visit merchant_bulk_discounts_path(@merch_1)

      within("#discount-deets") do

        expect(page).to have_link "New Discount", href: new_merchant_bulk_discount_path(@merch_1)
        
        click_link "New Discount"

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merch_1.id))
      end
    end

    it 'displays a link to delete next to each discount when clicked removes discount and redirects back to index' do
      visit merchant_bulk_discounts_path(@merch_1)
    
      within("#discount-deets-#{@bulk_discount_1.id}") do
        expect(page).to have_button "Delete"

        click_button "Delete"
      end
       expect(current_path).to eq(merchant_bulk_discounts_path(@merch_1))
       expect(page).to_not have_content(@bulk_discount_1.percent_discount)
 
      visit merchant_bulk_discounts_path(@merch_2)

      within("#discount-deets-#{@bulk_discount_3.id}") do
        expect(page).to have_button "Delete"

        click_button "Delete"  
      end
        expect(current_path).to eq(merchant_bulk_discounts_path(@merch_2))
        expect(page).to_not have_content("This discount gives #{@bulk_discount_3.percent_discount}%")
        expect(page).to_not have_content("when you buy #{@bulk_discount_3.quantity_threshold}")
    end

    it 'displays an upcoming holidays header and the name and date of next 3 upcoming holidays' do
      visit merchant_bulk_discounts_path(@merch_1)

      within("#holidays-") do
        expect(page).to have_content("Upcoming Holidays")
        expect(page).to have_content("Memorial Day ~ 2023-05-29")
        expect(page).to have_content("Juneteenth ~ 2023-06-19")
        expect(page).to have_content("Independence Day ~ 2023-07-04")
      end
    end
  end
end
 