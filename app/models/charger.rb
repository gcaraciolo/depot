class Charger
    def initialize(order, pay_type_params)
        @order = order
        @pay_type_params = pay_type_params
    end

    def charge!
        payment_details, payment_method = payment_params

        payment_result = Pago.make_payment(
            order_id: order.id,
            payment_method: payment_method,
            payment_details: payment_details
        )

        if payment_result.succeeded?
            OrderMailer.received(order).deliver_later
        else
            raise payment_result.error
        end
    end

    private
    
    attr_reader :order, :pay_type_params

    def payment_params
        payment_details = {}
        payment_method = nil

        case order.pay_type
        when "Check"
            payment_method = :check
            payment_details[:routing] = pay_type_params[:routing_number]
            payment_details[:account] = pay_type_params[:account_number]
        when "Credit card"
            payment_method = :credit_card
            month, year = pay_type_params[:expiration_date].split(//)
            payment_details[:cc_num] = pay_type_params[:credit_card_number]
            payment_details[:expiration_month] = month
            payment_details[:expiration_year] = year
        when "Purchase order"
            payment_method = :po
            payment_details[:po_num] = pay_type_params[:po_number]
        end

        [payment_details, payment_method]
    end
end