class HomeController < ApplicationController
    include BreadExpressHelpers::Baking

    authorize_resource :class => false

    def home
    end

    def about
    end

    def privacy
    end

    def contact
    end

    def cart 
    end
end