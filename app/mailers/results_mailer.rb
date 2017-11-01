class ResultsMailer < ApplicationMailer
    default from: "rso-survey@wsu.edu"
    def email_results(rsos)
        @rsos = rsos
        mail to: email, subject: "Your survey results" do |format|
            format.html { render "results.html"}
        end
    end
end
