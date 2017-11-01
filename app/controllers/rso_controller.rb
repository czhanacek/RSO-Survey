class RsoController < ApplicationController
  require "csv_upload"
  def index
  end

  def manage
    @rsos = Rso.order(:name)
  end

  def edit
    @rso = Rso.includes(:keywords).find(params[:id])
    
  end

  def bulk_upload

  end

  def modify_rso
    rso = Rso.find(params[:rso_id])
    flash[:success] = ""
    flash[:error] = ""
    rso.assign_attributes(name: params[:name], nickname: params[:nickname])
    if defined? params["keyword_weights"].keys
      params["keyword_weights"].keys.each do |k_id|
        keyword = Keyword.find(k_id)
        keyword.assign_attributes(weight: params[:keyword_weights][k_id])
        if(keyword.valid?)
          keyword.save
          flash[:success] += "Keyword updated successfully."
        else
          flash[:error] += "Keyword " + keyword.keyword + " not updated: " + keyword.errors.full_messages.join(", ")
        end
      end
    end
    if(rso.valid?)
      rso.save!
      flash[:success] = "RSO updated successfully."
    else
      flash[:error] += "RSO not updated: " + rso.errors.full_messages.join(", ")
    end
    if(flash[:error] == "")
      flash.delete("error")
    end
    if(flash[:success] == "")
      flash.delete("success")
    end
    redirect_to controller: 'rso', action: 'edit', id: params[:rso_id]
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

  def delete_rso
    rso = Rso.find(params[:rso_id])
    rso.destroy
    if(rso.destroyed?)
      flash[:success] = "RSO deleted successfully"
    else
      flash[:error] = "RSO not deleted"
    end
    redirect_to action: "manage"
  end

  def add_keyword
    new_keyword = Rso.find(params[:rso_id]).keywords.create({keyword: params[:keyword], weight: params[:weight]})
    if(new_keyword.valid?)
      flash[:success] = "Keyword added successfully to RSO"
    else
      flash[:error] = "Keyword not added to RSO: " + new_keyword.errors.full_messages.join(", ")
    end
    redirect_to controller: 'rso', action: 'edit', id: params[:rso_id]
  end

  def edit_keyword
    keyword = Keyword.find(params[:keyword_id])
    keyword.update(keyword: params[:keyword], weight: params[:weight])
    if(keyword.valid?)
      keyword.save!
      flash[:success] = "Keyword updated successfully"
    else
      flash[:error] = "Keyword not updated: " + keyword.errors.full_messages.join(", ")
    end
  end

  def delete_keyword
    Rso.find(params[:rso_id]).keywords.delete(params[:keyword_id])
    if(!(Rso.find(params[:rso_id]).keywords.where(id: params[:keyword_id]).exists?))
      flash[:success] = "Keyword deleted successfully"
    else
      flash[:error] = "Keyword not deleted"
    end

    redirect_to controller: 'rso', action: 'edit', id: params[:rso_id]
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
