class ResultsMailer < ApplicationMailer
    default from: "rso-survey@wsu.edu"
    def email_results(email, rsos, match_set_id)
        @match_set_id = match_set_id
        @rsos = rsos
        mail to: email, subject: "Your survey results" do |format|
            format.html { render "results.html"}
        end
    end
end
