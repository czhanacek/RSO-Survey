module ApplicationHelper
    def flash_messages
        if(flash[:error] == "")
            flash.delete("error")
        end
        if(flash[:success] == "")
            flash.delete("success")
        end
        flash_message_divs = ""
        if flash[:success]
            flash_message_divs += "<div class=\"alert alert-success\">#{ flash[:success]}</div>"
        end
        if flash[:error]
            flash_message_divs += "<div class=\"alert alert-danger\">#{ flash[:error]}</div>"
        end
        return flash_message_divs.html_safe
    end
end
