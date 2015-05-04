# File config/initializers/will_paginate.rb
# From https://gist.github.com/1214011

module WillPaginate
    module ActionView
        def will_paginate(collection = nil, options = {})
            options[:renderer] ||= LinkRenderer
            super.try :html_safe
        end

    # because will_paginate is cool but doesn't really work well with Materialize
    class LinkRenderer
        protected

        def html_container(html)
            tag :ul, html, container_attributes
        end

        def page_number(page)
            """
            <li class = #{page == current_page ? 'active disabled' : 'waves-effect'}>
                #{ page == current_page ? link(page, '#!') : link(page, page) }
            </li>
            """
        end

        def previous_or_next_page(page, text, classname = "I don't care")
            link_text = "<i class='mdi-navigation-chevron-#{classname == 'previous_page' ? 'left' : 'right'}'></i>"
            tag :li, link(link_text, page || '#!'), :class => (page ? 'waves-effect' : 'disabled')
        end

        def gap
            tag :li, link(super, '#!'), :class => 'disabled'
        end

        end
    end
end