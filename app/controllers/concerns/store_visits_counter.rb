module StoreVisitsCounter

    private

    def store_visits_count
        session[:counter]
    end

    def reset_store_visits_counter
        session[:counter] = 0
    end

    def increment_store_visits_counter
        if store_visits_count.nil?
            reset_store_visits_counter
        end

        session[:counter] += 1
    end
end