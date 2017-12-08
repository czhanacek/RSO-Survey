class SurveyController < ApplicationController
  before_filter :authenticate_user!, except: [:prelim1, :prelim1_submit, :prelim2_submit, :results, :email_results, :submit]
  def prelim1
    @category_groups = CategoryGroup.all
    render "prelim_survey", layout: "survey"
  end
  def prelim1_submit
    @categories = Category.where(category_group_id: params[:category_groups])
    render "prelim2_survey", layout: "survey"
  end

  def prelim2_submit
    @questions = Question.where(category_id: params[:categories]) + Question.where(category_id: -1)
    render "index", layout: "survey"
  end
  def index
    @questions = Question.order(:position)
    render "index", layout: "survey"
  end

  def new_question
  end

  def edit_question
    @q = Question.find(params[:id])
    if(@q.category == nil)
      @q.category_id = -1
    end
    @keywords = Keyword.uniq.pluck(:keyword).sort!
    @categories = Category.all
    
  end

  # Doesn't return anything, also doesn't redirect when done
  def modify_question_position(question, new_position)
    old_position = question.position
    if(new_position != nil && new_position != old_position)
      last_position = Question.all.order(position: :desc).first.position
      # If the position submitted by the user is greater than the last position in the survey,
      # just make the question the last one in the survey.
      questions_between = []
      if(new_position > last_position)
        new_position = last_position
        questions_between = Question.where("position >= ?", old_position).order(position: :desc)
        questions_between.each do |q|
          q.position -= 1
        end
      else
        if(new_position < old_position)
          questions_between = Question.where("position >= ? AND position < ?", new_position, old_position).order(position: :desc)
          questions_between.each do |question|
            question.position += 1
          end
        else
          questions_between = Question.where("position > ? AND position <= ?", old_position, new_position).order(position: :desc)
          questions_between.each do |question|
            question.position -= 1
          end
        end
      end
      questions_between.each do |question|
        question.save!
      end
    end
    return "", ""
  end

  def update_answer_titles(answer_titles)
    answer_titles.keys.each do |answer_id|
      answer = Answer.find(answer_id)
      answer.assign_attributes(answer_title: answer_titles[answer_id])
      if(answer.changed?)
        if(answer.valid?)
          answer.save
          flash[:success] += "Title of answer \"" + answer.answer_title + "\" updated successfully. "
        else
          flash[:error] += "Title of answer \"" + answer.answer_title + "\" not updated successfully: " + answer.errors.full_messages.join(", ")
        end
      end
    end
    
  end


  def update_answer_positions(answer_positions)
    answer_positions.keys.each do |answer_id|
      answer = Answer.find(answer_id)
      if(answer.position != answer_positions[answer_id].to_i)
        answer.insert_at(answer_positions[answer_id].to_i)
        if(answer.changed?)
          if(answer.valid?)
            answer.save
            flash[:success] += "Position of answer \"" + answer.answer_title + "\" updated successfully. "
          else
            flash[:error] += "Position of answer \"" + answer.answer_title + "\" not updated successfully: " + answer.errors.full_messages.join(", ")
          end
        end
      end
    end
  end

  def update_keyword_titles(keyword_titles)
    if keyword_titles
      keyword_titles.keys.each do |keyword_id|
        keyword = Keyword.find(keyword_id)
        keyword.assign_attributes(keyword: keyword_titles[keyword_id])
        if(keyword.changed?)
          if(keyword.valid?)
            keyword.save
            flash[:success] += "Title of keyword \"" + keyword.keyword + "\" updated successfully. "
          else
            flash[:error] += "Title of keyword \"" + keyword.keyword + "\" not updated successfully: " + keyword.errors.full_messages.join(", ")
          end
        end
      end
    end
  end

  def update_keyword_weights(keyword_weights)
    if keyword_weights
      keyword_weights.keys.each do |keyword_id|
        keyword = Keyword.find(keyword_id)
        keyword.assign_attributes(weight: keyword_weights[keyword_id])
        if(keyword.changed?)
          if(keyword.valid?)
            keyword.save
            flash[:success] += "Weight of keyword \"" + keyword.keyword + "\" updated successfully. "
          else
            flash[:error] += "Weight of keyword \"" + keyword.keyword + "\" not updated successfully: " + keyword.errors.full_messages.join(", ")
          end
        end
      end
    end
  end


  def update_question_button(params)
    q = Question.find(params[:id])
    new_position = params[:position].to_i
    new_category = params[:category].to_i
    if(new_category == -1)
      new_category = nil
    end
    modify_question_position(q, new_position)
    # update answer titles
    update_answer_titles(params[:answer_titles])
    
    # update answer positions
    update_answer_positions(params[:answer_positions])

    # update keyword titles
    update_keyword_titles(params[:keyword_titles])
    # update keyword weights
    update_keyword_weights(params[:keyword_weights])
    q.assign_attributes(:question_title => params[:question_title], :position => new_position, :category_id => new_category)
    if(q.changed?)
      if(q.valid?)
        q.save
        flash[:success] += "Question updated successfully"
      else
        flash[:error] += "Question not updated: " + q.errors.full_messages.join(", ")
      end
    end
  end
  
  # directs button clicks on the edit_question page to their appropriate places
  def modify_question
    flash[:success] = ""
    flash[:error] = ""
    if(params[:update_question])
      update_question_button(params)
      if(flash[:error] == "")
        flash.delete("error")
      end
      if(flash[:success] == "")
        flash.delete("success")
      end
      redirect_to controller: 'survey', action: 'edit_question', id: params[:id]
    elsif(params[:delete_question])
      delete_question_button(params)
      if(flash[:error] == "")
        flash.delete("error")
      end
      if(flash[:success] == "")
        flash.delete("success")
      end
      redirect_to action: "manage"
    elsif(params[:delete_keyword])
      delete_keyword_button(params[:delete_keyword])
      if(flash[:error] == "")
        flash.delete("error")
      end
      if(flash[:success] == "")
        flash.delete("success")
      end
      redirect_to controller: 'survey', action: 'edit_question', id: params[:id]
    elsif(params[:add_keyword])
      add_keyword_button(params)
      if(flash[:error] == "")
        flash.delete("error")
      end
      if(flash[:success] == "")
        flash.delete("success")
      end
      redirect_to controller: 'survey', action: 'edit_question', id: params[:id]
    elsif(params[:add_answer])
      add_answer_button(params)
      if(flash[:error] == "")
        flash.delete("error")
      end
      if(flash[:success] == "")
        flash.delete("success")
      end
      redirect_to controller: 'survey', action: 'edit_question', id: params[:id]
    elsif(params[:delete_answer])
      delete_answer_button(params[:delete_answer])
      if(flash[:error] == "")
        flash.delete("error")
      end
      if(flash[:success] == "")
        flash.delete("success")
      end
      redirect_to controller: 'survey', action: 'edit_question', id: params[:id]
    end
    

    
  end

  def add_answer_button(params)
    @answer = Answer.create(question_id: params[:id], answer_title: params[:new_answer_title], position: params[:new_answer_position])
    if(@answer.valid?)
      @answer.save
      flash[:success] = "Answer created successfully"
    else
      flash[:error] = "Answer not created: " + @answer.errors.full_messages.join(", ")
    end
  end

  def create_question
    @question = Question.create(question_title: params[:question_title])
    last_position = 0
    if(Question.exists? && Question.all.order(position: :desc).first.position != nil)
      last_position = Question.all.order(position: :desc).first.position
    end
    if(params[:position] == "")
      # Add the question to the end of the survey
      @question.position = last_position + 1
    else
      # If the position submitted by the user is greater than the last position in the survey,
      # just make the question the last one in the survey.
      if(params[:position].to_i > last_position)
        @question.position = last_position + 1
      else
        @questionsAfter = Question.where("position >= ?", params[:position].to_i).order(position: :desc)
        @questionsAfter.each do |q|
          q.position += 1
        end
        @questionsAfter.each do |q|
          q.save!
        end
      end
    end
    @question.save(:validate => false)
    nextOrder = 0

    # These if statments prevent empty answers from being created if the user wants
    # less than 4 answers to a question.
    if(params[:answer1] != "")
      nextOrder += 1
      @question.answers.create(answer_title: params[:answer1], position: nextOrder)
    end
    if(params[:answer2] != "")
      nextOrder += 1
      @question.answers.create(answer_title: params[:answer2], position: nextOrder)
    end
    if(params[:answer3] != "")
      nextOrder += 1
      @question.answers.create(answer_title: params[:answer3], position: nextOrder)
    end
    if(params[:answer4] != "")
      nextOrder += 1
      @question.answers.create(answer_title: params[:answer4], position: nextOrder)
    end

    if(@question.valid?)
      flash[:success] = "Question created successfully!"
    else
      flash[:error] = "Question not created: " + @question.errors.full_messages.join(", ")
      @question.destroy
    end

    redirect_to action: "manage"
  end

  def manage
    @questionNum = Question.count(:question_title)
    @questions = Question.order(:position)
  end

  def add_keyword_button(params)
    answer = Answer.find(params[:add_keyword].to_int)
    answer.keywords.create(keyword: params[:new_keyword_title][params[:add_keyword]], weight: params[:new_keyword_weight][params[:add_keyword]])
    flash[:success] = "Keyword added successfully!"
  end

  def delete_question_button(params)
    question = Question.find(params[:id].to_int)
    @questionsAfter = Question.where("position >= ?", question.position).order(position: :desc)
    @questionsAfter.each do |q|
      q.position -= 1
    end
    @questionsAfter.each do |q|
      q.save!
    end

    question.destroy
    if(question.destroyed?)
      flash[:success] = "Question deleted successfully"
    else
      flash[:error] = "Question not deleted successfully: " + question.errors.full_messages.join(", ")
    end
  end

  def delete_answer_button(answer_id)
    answer = Answer.find(answer_id)
    question_id = answer.question_id
    answer.destroy
    if(answer.destroyed?)
      flash[:success] = "Answer deleted successfully"
    else
      flash[:error] = "Answer not deleted: " + answer.erros.full_messages.join(", ")
    end
  end

  def edit_answer
    @a = Answer.find(params[:id])
    @q = @a.question
  end

  def modify_answer
    a = Answer.find(params[:id].to_int)
    old_position = a.position
    new_position = params[:position].to_i
    last_positio = Answer.all.order(position: :desc).first.position
    answersBetween = {}
    if(new_position > last_position)
      new_position = last_position
    end

    if(new_position > 4)
      new_position = 4
    else
      if(old_position != nil && old_position != new_position)
        if(new_position < old_position)
          answersBetween = Answer.where("position >= ? AND position < ?", new_position, old_position).order(position: :desc)
          answersBetween.each do |answer|
            answer.position += 1
          end
        else
          answersBetween = Answer.where("position > ? AND position <= ?", old_position, new_position).order(position: :desc)
          answersBetween.each do |answer|
            answer.position -= 1
          end
        end
      end
      answersBetween.each do |answer|
        answer.save!
      end
    end
    flash[:success] = "Answer updated"
    a.update(:answer_title => params[:answer_title], :position => new_position)
    redirect_to controller: 'survey', action: 'edit_question', id: a.question.id
  end

  def edit_keyword
    keyword = Keyword.find(params[:keyword_id])
    old_keyword = keyword.keyword
    keyword.update(keyword: params[:keyword], weight: params[:weight])
    if(keyword.valid?)
      keyword.save!
      keywords_to_update = Keyword.where(keyword: old_keyword)
      keywords_to_update.each do |k|
        k.update(keyword: params[:keyword])
        k.save!
      end
      flash[:success] = "Keyword updated successfully"
    else
      flash[:error] = "Keyword not updated: " + keyword.errors.full_messages.join(", ")
    end
    redirect_to controller: 'survey', action: 'edit_question', id: params[:question_id]
  end

  def delete_keyword_button(id)
    keyword = Keyword.find(id)
    keyword.destroy
    if(keyword.destroyed?)
      flash[:success] = "Keyword deleted successfully!"
    else
      flash[:error] = "Keyword not deleted: " + keyword.errors.full_messages.join(", ")
    end
  end

  def submit
    response = Response.create()
    if(params["question"])
      params["question"].keys.each do |q|
        response.answers << Answer.find(params["question"][q])
      end
      user_keywords = {}
      response.answers.each do |a|
        answer_weight_sum = a.keywords.sum(:weight)
        keyword_sum = a.keywords.count()
        a.keywords.each do |k|
          user_keywords[k.keyword] = k.weight.to_f / answer_weight_sum
          #user_keywords[k.keyword] /= keyword_sum
        end
        a.keywords.each do |k|
          user_keywords[k.keyword] = k.weight.to_f / answer_weight_sum
        end
      end
      rso_keywords = {}
      rsos = Rso.all
      rsos.each do |r|
        rso_keywords[r.id] = {}
        keyword_weight_sum = r.keywords.sum(:weight)
        keyword_sum = r.keywords.count()
        # normalize keyword weights so they are relative within the RSO
        r.keywords.each do |k|
          rso_keywords[r.id][k.keyword] = k.weight.to_f / keyword_weight_sum
          #rso_keywords[r.id][k.keyword] =
        end
      end
      rso_match_strengths = {}
      rso_keywords.keys.each do |rso_id|
        rso_match_strengths[rso_id] = 0
        rso_keywords[rso_id].keys.each do |keyword|
          if(user_keywords.key?(keyword))
            rso_keywords[rso_id][keyword] = rso_keywords[rso_id][keyword] * user_keywords[keyword]
            rso_match_strengths[rso_id] += rso_keywords[rso_id][keyword]
          end
        end
      end

      # Rank the matches from highest to lowest.
      rso_match_strengths = rso_match_strengths.sort_by{ |rso_id, strength| strength}.reverse
      match_set_id = []
      if(rso_match_strengths[0][1] > 0)
        match_set_id = MatchSet.create(rso1_id: rso_match_strengths[0][0])
        if(rso_match_strengths[1][1] > 0)
          match_set_id.update(rso2_id: rso_match_strengths[1][0])
          if(rso_match_strengths[2][1] > 0)
            match_set_id.update(rso3_id: rso_match_strengths[2][0])
            if(rso_match_strengths[3][1] > 0)
              match_set_id.update(rso4_id: rso_match_strengths[3][0])
              if(rso_match_strengths[4][1] > 0)
                match_set_id.update(rso5_id: rso_match_strengths[4][0])
              end
            end
          end
        end
      end
      
      redirect_to action: "results", match_set_id: match_set_id.id
      #ResultsMailer.email_results("charlie.hanacek@wsu.edu").deliver_now
      
    else
      flash[:error] = "You need to answer at least one survey question. Please try again."
      redirect_to action: "index"
    end
  end

  def results
    match_set = MatchSet.find(params[:match_set_id])
    @match_set_id = params[:match_set_id]
    @rsos = []
    if(match_set.rso1_id != nil)
      @rsos += [Rso.find(match_set.rso1_id)]
      if(match_set.rso2_id != nil)
        @rsos += [Rso.find(match_set.rso2_id)]
        if(match_set.rso3_id != nil)
          @rsos += [Rso.find(match_set.rso3_id)]
          if(match_set.rso4_id != nil)
            @rsos += [Rso.find(match_set.rso4_id)]
            if(match_set.rso5_id != nil)
              @rsos += [Rso.find(match_set.rso5_id)]
            end
          end
        end
      end
    end
  end

  def email_results
    # TODO: Use a returned result from results method above to minimize repeated code
    match_set = MatchSet.find(params[:matchset_id])
    @rsos = []
    if(match_set.rso1_id != nil)
      @rsos += [Rso.find(match_set.rso1_id)]
      if(match_set.rso2_id != nil)
        @rsos += [Rso.find(match_set.rso2_id)]
        if(match_set.rso3_id != nil)
          @rsos += [Rso.find(match_set.rso3_id)]
          if(match_set.rso4_id != nil)
            @rsos += [Rso.find(match_set.rso4_id)]
            if(match_set.rso5_id != nil)
              @rsos += [Rso.find(match_set.rso5_id)]
            end
          end
        end
      end
    end
    ResultsMailer.email_results(params[:email], @rsos, params[:matchset_id]).deliver_now
    flash[:success] = "Email sent!"
    redirect_to action: "results", match_set_id: params[:matchset_id]
  end

  def bulk_download
    @questions = Question.all
    send_data @questions.to_csv, filename: "rso_survey_questions.csv", disposition: "attachment", type: "text/csv"
  end

  def bulk_upload

  end

  def bulk_upload_post
    if(params[:csv].nil?)
      flash[:error] = "You need to select a CSV file to upload"
    else
      csv = Csv.create(csvfile: params[:csv][:csvfile])
      new_count = 0
      update_count = 0
      CSV.foreach(csv.csvfile.path) do |row|
        if(row[0] != "Question")
          if(row[0] != nil) 
            if(Question.where("question_title = ?", row[0]).empty?)
              Question.create(question_title: row[0], position: row[1])
            else
              Question.where("question_title = ?", row[0]).update(position: row[1])
            end
            if(row[2] == "No category")
              Question.where("question_title = ?", row[0]).update(category: nil)
            else
              if(CategoryGroup.where("title = ?", row[3]).empty?)
                newcatgroup = CategoryGroup.create(title: row[3])
                if(Category.where("title = ?", row[2]).empty?) # The user updated the Category Group of a Category to a Category Group not yet in the database
                  newcat = Category.create(title: row[2], category_group: newcatgroup)
                  Question.where("question_title = ?", row[0]).update(category: newcat)
                  new_count += 1
                else
                  Category.where("title = ?", row[2]).update(category_group: newcatgroup)
                end
              else
                if(Category.where("title = ?", row[2]).empty?) # The user updated the Category to a Category not yet in the database but the CategoryGroup already exists in the database
                  newcat = Category.create(title: row[2], category_group: CategoryGroup.where("title = ?", row[3]).first)
                  Question.where("question_title = ?", row[0]).update(category: newcat)
                else
                  Category.where("title = ?", row[2]).update(category_group: CategoryGroup.where("title = ?", row[3]).first)
                end
              end
            end
          end
          # throw out the answers that existed previously
          Question.where("question_title = ?", row[0]).first.answers.destroy_all
          if(row[4] != "")
            a = Answer.create(answer_title: row[4], position: 1, question: Question.where("question_title = ?", row[0]).first)
            if(row[8] != nil && row[9] != nil)
              Keyword.create(keyword: row[8], weight: row[9], answer_id: a.id)
            end
            if(row[10] != nil && row[11] != nil)
              Keyword.create(keyword: row[10], weight: row[11], answer_id: a.id)
            end
            if(row[12] != nil && row[13] != nil)
              Keyword.create(keyword: row[12], weight: row[13], answer_id: a.id)
            end
            if(row[14] != nil && row[15] != nil)
              Keyword.create(keyword: row[14], weight: row[15], answer_id: a.id)
            end
            if(row[16] != nil && row[17] != nil)
              Keyword.create(keyword: row[16], weight: row[17], answer_id: a.id)
            end
          end
          if(row[5] != "")
            a = Answer.create(answer_title: row[5], position: 2, question: Question.where("question_title = ?", row[0]).first)
            if(row[18] != nil && row[19] != nil)
              Keyword.create(keyword: row[18], weight: row[19], answer_id: a.id)
            end
            if(row[20] != nil && row[21] != nil)
              Keyword.create(keyword: row[20], weight: row[21], answer_id: a.id)
            end
            if(row[22] != nil && row[23] != nil)
              Keyword.create(keyword: row[22], weight: row[23], answer_id: a.id)
            end
            if(row[24] != nil && row[25] != nil)
              Keyword.create(keyword: row[24], weight: row[25], answer_id: a.id)
            end
            if(row[26] != nil && row[27] != nil)
              Keyword.create(keyword: row[26], weight: row[27], answer_id: a.id)
            end
          end
          if(row[6] != "")
            a = Answer.create(answer_title: row[6], position: 3, question: Question.where("question_title = ?", row[0]).first)
            if(row[28] != nil && row[29] != nil)
              Keyword.create(keyword: row[28], weight: row[29], answer_id: a.id)
            end
            if(row[30] != nil && row[31] != nil)
              Keyword.create(keyword: row[30], weight: row[31], answer_id: a.id)
            end
            if(row[32] != nil && row[33] != nil)
              Keyword.create(keyword: row[32], weight: row[33], answer_id: a.id)
            end
            if(row[34] != nil && row[35] != nil)
              Keyword.create(keyword: row[34], weight: row[35], answer_id: a.id)
            end
            if(row[36] != nil && row[37] != nil)
              Keyword.create(keyword: row[36], weight: row[37], answer_id: a.id)
            end
          end
          if(row[7] != "")
            a = Answer.create(answer_title: row[7], position: 4, question: Question.where("question_title = ?", row[0]).first)
            if(row[38] != nil && row[39] != nil)
              Keyword.create(keyword: row[38], weight: row[39], answer_id: a.id)
            end
            if(row[40] != nil && row[41] != nil)
              Keyword.create(keyword: row[40], weight: row[41], answer_id: a.id)
            end
            if(row[42] != nil && row[43] != nil)
              Keyword.create(keyword: row[42], weight: row[43], answer_id: a.id)
            end
            if(row[44] != nil && row[45] != nil)
              Keyword.create(keyword: row[44], weight: row[45], answer_id: a.id)
            end
            if(row[46] != nil && row[47] != nil)
              Keyword.create(keyword: row[46], weight: row[47], answer_id: a.id)
            end
          end
        end
      end
      flash[:success] = "Upload successful"
      Csv.destroy_all
    end
    redirect_to action: "bulk_upload"
  end
end
