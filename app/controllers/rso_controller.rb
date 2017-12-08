class RsoController < ApplicationController
  before_filter :authenticate_user!
  require "csv_upload"
  def index
    # A static page (that we don't even use...)
  end

  def manage
    @rsos = Rso.order(:name)
  end

  def edit
    @rso = Rso.includes(:keywords).find(params[:id])
  end

  def go_to_edit_rso
    redirect_to controller: 'rso', action: 'edit', id: params[:rso_id]
  end

  def go_to_rso_index
    redirect_to controller: 'rso', action: 'edit', id: params[:rso_id]
  end
  # Directs action when a button on the rso_edit page is clicked
  # Functions called in modify_rso should not contain a redirect_to
  # or a render call.
  def modify_rso
    if(params[:edit_rso_attributes])
      edit_rso_attributes(params)
      go_to_edit_rso()
    elsif(params[:delete_rso])
      delete_rso(params)
      go_to_rso_index()
    elsif(params[:edit_keyword])
      edit_keyword(params)
      go_to_edit_rso()
    elsif(params[:add_keyword])
      add_keyword(params)
      go_to_edit_rso()
    elsif(params[:delete_keyword])
      delete_keyword(params)
      go_to_edit_rso()
    end
  end

  # Updates the attributes of the RSO
  def edit_rso_attributes(params)
    rso = Rso.find(params[:rso_id])
    rso.update(name: params[:rso_name], nickname: params[:rso_nickname], website: params[:rso_website], description: params[:rso_description])
    if(rso.valid?)
      rso.save!
      flash[:success] = "RSO updated successfully."
    else
      flash[:error] += "RSO not updated: " + rso.errors.full_messages.join(", ")
    end
    
  end

  def delete_rso(params)
    rso = Rso.find(params[:rso_id])
    rso.destroy
    if(rso.destroyed?)
      flash[:success] = "RSO deleted successfully"
    else
      flash[:error] = "RSO not deleted"
    end
    redirect_to action: "manage"
  end

  def edit_keyword(params)
    keyword = Keyword.find(params[:edit_keyword])
    if(params[:keyword_weights])
      keyword.update(weight: params[:keyword_weights][params[:edit_keyword]])
    end
    if(keyword.valid?)
      keyword.save!
      flash[:success] = "Keyword updated successfully. "
    else
      flash[:error] = "Keyword not updated: " + keyword.errors.full_messages.join(", ") + ". "
    end
  end
  
  def add_keyword(params)
    new_keyword = Rso.find(params[:rso_id]).keywords.create({keyword: params[:new_keyword_title], weight: params[:new_keyword_weight]})
    if(new_keyword.valid?)
      flash[:success] = "Keyword added successfully to RSO"
    else
      flash[:error] = "Keyword not added to RSO: " + new_keyword.errors.full_messages.join(", ") + ". "
    end
  end

  def delete_keyword(params)
    # We want to delete this keyword rather than destroy it because we just want to remove its ties with the RSO.
    Rso.find(params[:rso_id]).keywords.delete(params[:delete_keyword])
    if(!(Rso.find(params[:rso_id]).keywords.where(id: params[:delete_keyword]).exists?))
      flash[:success] = "Keyword deleted successfully. "
    else
      flash[:error] = "Keyword not deleted."
    end
  end

  def create_rso
    rso = Rso.create({name: params[:name], nickname: params[:nickname]})
    if(rso.valid?)
      flash[:success] = "RSO created successfully"
    else
      flash[:error] = "RSO not created: " + rso.errors.full_messages.join(", ")
    end
    redirect_to action: "manage"
  end

  def bulk_download
    @rsos = Rso.all
    send_data @rsos.to_csv, filename: "rso_survey_rsos.csv", disposition: "attachment", type: "text/csv"
  end

  def bulk_upload
    # This is just a static page
  end

  def bulk_upload_post
    csv = Csv.create(csvfile: params[:csv][:csvfile])
    new_count = 0
    update_count = 0
    CSV.foreach(csv.csvfile.path) do |row|
      puts row.to_s
      if(row[0] != "Name")
        if(row[0] != nil) 
          if(Rso.where("name = ?", row[0]).empty?)
            Rso.create(name: row[0], nickname: row[1], website: row[2], description: row[3])
            new_count += 1
          else
            Rso.where("name = ?", row[0]).update(name: row[0], nickname: row[1], website: row[2], description: row[3])
            update_count += 1
          end
        end
        if(row[4] != nil && row[5] != nil)
          if(Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[4]).empty?)
            Rso.where("name = ?", row[0]).first.keywords.create({keyword: row[4], weight: row[5]})
          else
            Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[4]).update(weight: row[5])
          end
        end
        if(row[6] != nil && row[7] != nil)
          if(Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[6]).empty?)
            Rso.where("name = ?", row[0]).first.keywords.create({keyword: row[6], weight: row[7]})
          else
            Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[6]).update(weight: row[7])
          end
        end
        if(row[8] != nil && row[9] != nil)
          if(Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[8]).empty?)
            Rso.where("name = ?", row[0]).first.keywords.create({keyword: row[8], weight: row[9]})
          else
            Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[8]).update(weight: row[9])
          end
        end
        if(row[10] != nil && row[11] != nil)
          if(Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[10]).empty?)
            Rso.where("name = ?", row[0]).first.keywords.create({keyword: row[10], weight: row[11]})
          else
            Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[10]).update(weight: row[11])
          end
        end
        if(row[12] != nil && row[13] != nil)
          if(Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[12]).empty?)
            Rso.where("name = ?", row[0]).first.keywords.create({keyword: row[12], weight: row[13]})
          else
            Rso.where("name = ?", row[0]).first.keywords.where("keyword = ?", row[12]).update(weight: row[13])
          end
        end
      end
    end
    flash[:success] = "Updated: " + update_count.to_s + "\nNew: " + new_count.to_s
    Csv.destroy_all
    redirect_to action: "bulk_upload"
  end
end
