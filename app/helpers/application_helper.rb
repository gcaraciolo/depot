module ApplicationHelper
    def render_if(condition, record)
        render record if condition
    end

    def current_path_begins_with(pattern)
        request.path =~ /#{pattern}*/
    end
end
