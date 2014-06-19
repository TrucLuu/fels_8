class Admin::MonitorsController < ApplicationController
  before_action :signed_in_admin
  layout  'admin/layouts/admin'
  def index
    @models = []
    ActiveRecord::Base.connection.tables.each do |table|
      @models << table.capitalize.singularize.camelize.constantize rescue nil
    end
  end

  def export
    model = params[:model].constantize rescue nil
    if model
      send_data generate_csv(model), filename: "#{model.table_name}.csv"
    else
      redirect_to admin_monitors_path
    end
  end

  def import
    model = params[:model].constantize rescue nil
    file = params[:file]
    if file
      import_csv model, file
      flash[:success] = 'Successfully import'
    else
      flash[:error] = 'No file uploaded'
    end
    redirect_to admin_monitors_path
  end

  def generate_csv model
    CSV.generate do |csv|
      csv << model.column_names
      model.all.each { |row| csv << row.attributes.values_at(*model.column_names) }
    end
  end

  def import_csv model, file
    CSV.foreach file.path, headers: true do |row|
      records = model.where id: row[0]
      model.crete row.to_hash if records.empty?
    end
  end
end
