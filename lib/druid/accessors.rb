require 'druid/elements'
#
# Contains the class level methods that are inserted into your page class
# when you include the PageObject module.  These methods will generate another
# set of methods that provide access to the elements on the web pages.
#
module Druid
  module Accessors
    #
    # Specify the url for the page.  A call to this method will generate a
    # 'goto' method to take you to the page.
    #
    # @param [String] the url for the page.
    #
    def page_url(url)
      define_method("goto") do
        driver.goto url
      end
    end

    #
    # Identify an element as existing within a frame or iframe.
    #
    # @example
    #  in_frame(:id => 'frame_id') do |frame|
    #    text_field(:first_name, :id=> 'fname', :frame => frame)
    #  end
    #
    # @param [Hash] identifier how we find the frame. The valid keys are:
    #    * :id
    #    * :index
    #    * :name
    # @param block that contains the calls to elements that exist inside the frame.
    #
    def in_frame(identifier, frame=nil, &block)
      frame = [] if frame.nil?
      frame << {frame: identifier}
      block.call(frame)
    end
    #
    # Identify an element as existing within a frame or iframe.
    #
    # @example
    #  in_iframe(:id => 'frame_id') do |frame|
    #    text_field(:first_name, :id=> 'fname', :frame => frame)
    #  end
    #
    # @param [Hash] identifier how we find the frame. The valid keys are:
    #    * :id
    #    * :index
    #    * :name
    # @param block that contains the calls to elements that exist inside the frame.
    #
    def in_iframe(identifier, frame=nil, &block)
      frame = [] if frame.nil?
      frame << {iframe: identifier}
      block.call(frame)
    end

    #
    # adds three methods - one to select a link, another
    # to return a PageObject::Elements::Link object representing
    # the link, and another that checks the link's existence.
    #
    # @example
    #   link(:add_to_cart, :text => "Add to Cart")
    #   # will generate 'add_to_cart', 'add_to_cart_element', and 'add_to_cart?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a link. The valid values are:
    #   :class
    #   :href
    #   :id
    #   :index
    #   :name
    #   :text
    #   :xpath
    #   :link
    #   :link_text
    def link(name, identifier=nil, &block)
      define_method(name) do
        return click_link_for identifier.clone unless block_given?
        self.send("#{name}_element").click
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        link_for(identifier.clone)
        # block ? call_block(&block) : link_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        link_for(identifier.clone).exist?
      end
      alias_method "#{name}_link".to_sym, "#{name}_element".to_sym
    end

    #
    # adds four methods to the page object - one to set text in a text field,
    # another to retrieve text from a text field, another to return the text
    # field element, another to check the text field's existence.
    #
    # @example
    #   text_field(:first_name, :id => "first_name")
    #   # will generate 'first_name', 'first_name=', 'first_name_element',
    #   # 'first_name?' methods
    #
    # @param  the name used for the generated methods
    # @param identifier how we find a text_field.  The valid values are:
    #   :class
    #   :css
    #   :id
    #   :index
    #   :name
    #   :tag_name
    #   :xpath
    #   :text
    #   :title
    def text_field(name, identifier=nil, &block)
      define_method(name) do
        return text_field_value_for identifier.clone unless block_given?
        self.send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return text_field_value_set(identifier.clone, value) unless block_given?
        self.send("#{name}_element").value = value
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        text_field_for(identifier.clone)
        # block ? call_block(&block) : text_field_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        text_field_for(identifier.clone).exist?
      end
      alias_method "#{name}_text_field".to_sym, "#{name}_element".to_sym
    end

    #
    # adds five methods - one to check, another to uncheck, another
    # to return the state of a checkbox, another to return
    # a PageObject::Elements::CheckBox object representing the checkbox, and
    # a final method to check the checkbox's existence.
    #
    # @example
    #   checkbox(:active, :name => "is_active")
    #   # will generate 'check_active', 'uncheck_active', 'active_checked?',
    #   # 'active_element', and 'active?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a checkbox.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :name
    #   :xpath
    #   :value
    #
    def checkbox(name, identifier=nil, &block)
      define_method("check_#{name}") do
        return check_checkbox identifier.clone unless block_given?
        self.send("#{name}_element").check
      end
      define_method("uncheck_#{name}") do
        return uncheck_checkbox identifier.clone unless block_given?
        self.send("#{name}_element").uncheck
      end
      define_method("#{name}_checked?") do
        return checkbox_checked? identifier.clone unless block_given?
        self.send("#{name}_element").checked?
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        checkbox_for(identifier.clone)
        # block ? call_block(&block) : checkbox_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        checkbox_for(identifier.clone).exist?
      end
      alias_method "#{name}_checkbox".to_sym, "#{name}_element".to_sym
    end

    #
    # adds four methods - one to select an item in a drop-down,
    # another to fetch the currently selected item, another
    # to retrieve the select list element, and another to check the
    # drop down's existence.
    #
    # @example
    #   select_list(:state, :id => "state")
    #   # will generate 'state', 'state=', 'state_element', 'state?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a select_list.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :name
    #   :xpath
    #
    def select_list(name, identifier=nil, &block)
      define_method(name) do
        return select_list_value_for identifier.clone unless block_given?
        self.send("#{name}_element").value
      end
      define_method("#{name}=") do |value|
        return select_list_value_set(identifier.clone, value) unless block_given?
        self.send("#{name}_element").select(value)
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        select_list_for(identifier.clone)
        # block ? call_block(&block) : select_list_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        select_list_for(identifier.clone).exist?
      end
      alias_method "#{name}_select_list".to_sym, "#{name}_element".to_sym
    end

    #
    # adds five methods - one to select, another to clear,
    # another to return if a radio button is selected,
    # another method to return a PageObject::Elements::RadioButton
    # object representing the radio button element, and another to check
    # the radio button's existence.
    #
    # @example
    #   radio_button(:north, :id => "north")
    #   # will generate 'select_north', 'clear_north', 'north_selected?',
    #   # 'north_element', and 'north?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a radio_button.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :name
    #   :xpath
    #   :value
    #
    def radio_button(name, identifier=nil, &block)
      define_method("select_#{name}") do
        return select_radio identifier.clone unless block_given?
        self.send("#{name}_element").select
      end
      define_method("clear_#{name}") do
        return clear_radio identifier.clone unless block_given?
        self.send("#{name}_element").clear
      end
      define_method("#{name}_selected?") do
        return radio_selected? identifier.clone unless block_given?
        self.send("#{name}_element").selected?
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        radio_button_for(identifier.clone)
        # block ? call_block(&block) : radio_button_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        radio_button_for(identifier.clone).exist?
      end
      alias_method "#{name}_radio_button".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to click a button, another to
    # return the button element, and another to check the button's existence.
    #
    # @example
    #   button(:purchase, :id => 'purchase')
    #   # will generate 'purchase', 'purchase_element', and 'purchase?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a button.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :name
    #   :text
    #   :xpath
    #   :src
    #   :alt
    #
    def button(name, identifier=nil, &block)
      define_method(name) do
        return click_button_for identifier.clone unless block_given?
        self.send("#{name}_element").click
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        button_for(identifier.clone)
        # block ? call_block(&block) : button_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        button_for(identifier.clone).exist?
      end
      alias_method "#{name}_button".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text from a div,
    # another to return the div element, and another to check the div's existence.
    #
    # @example
    #   div(:message, :id => 'message')
    #   # will generate 'message', 'message_element', and 'message?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a div.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :xpath
    #   :name
    #   :text
    #   :value
    #
    def div(name, identifier=nil, &block)
      define_method(name) do
        return div_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        div_for(identifier.clone)
        # block ? call_block(&block) : div_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        div_for(identifier.clone).exist?
      end
      alias_method "#{name}_div".to_sym, "#{name}_element".to_sym
    end

    #
    # adds two methods - one to retrieve the table element, and another to
    # check the table's existence.
    #
    # @example
    #   table(:cart, :id => 'shopping_cart')
    #   # will generate a 'cart_element' and 'cart?' method
    #
    # @param the name used for the generated methods
    # @param identifier how we find a table.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :xpath
    #   :name
    #
    def table(name, identifier=nil, &block)
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        table_for(identifier.clone)
        # block ? call_block(&block) : table_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        table_for(identifier.clone).exist?
      end
      alias_method "#{name}_table".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text from a table cell,
    # another to return the table cell element, and another to check the cell's
    # existence.
    #
    # @example
    #   cell(:total, :id => 'total_cell')
    #   # will generate 'total', 'total_element', and 'total?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a cell.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :xpath
    #   :name
    #   :text
    #
    def cell(name, identifier=nil, &block)
      define_method(name) do
        return cell_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        cell_for(identifier.clone)
        # block ? call_block(&block) : cell_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        cell_for(identifier.clone).exist?
      end
      alias_method "#{name}_cell".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text from a span,
    # another to return the span element, and another to check the span's existence.
    #
    # @example
    #   span(:alert, :id => 'alert')
    #   # will generate 'alert', 'alert_element', and 'alert?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a span.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :xpath
    #   :name
    #   :text
    #
    def span(name, identifier=nil, &block)
      define_method(name) do
        return span_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        span_for(identifier.clone)
        # block ? call_block(&block) : span_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        span_for(identifier.clone).exist?
      end
      alias_method "#{name}_span".to_sym, "#{name}_element".to_sym
    end

    #
    # adds two methods - one to retrieve the image element, and another to
    # check the image's existence.
    #
    # @example
    #   image(:logo, :id => 'logo')
    #   # will generate 'logo_element' and 'logo?' methods
    #
    # @param the name used for the generated methods
    # @param identifier how we find a image.  The valid values are:
    #   :class
    #   :id
    #   :index
    #   :name
    #   :xpath
    #   :alt
    #   :src
    #
    def image(name, identifier=nil, &block)
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        image_for(identifier.clone)
        # block ? call_block(&block) : image_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        image_for(identifier.clone).exist?
      end
      alias_method "#{name}_image".to_sym, "#{name}_element".to_sym
    end

    #
    # adds two methods - one to retrieve the form element, and another to
    # check the form's existence.
    #
    # @example
    #   form(:login, :id => 'login')
    #   # will generate 'login_element' and 'login?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a form.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :xpath
    #   * :name
    #   * :action
    #
    def form(name, identifier=nil, &block)
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        form_for(identifier.clone)
        # block ? call_block(&block) : form_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        form_for(identifier.clone).exist?
      end
      alias_method "#{name}_form".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods to the page object - one to get the text from a hidden field,
    # another to retrieve the hidden field element, and another to check the hidden
    # field's existence.
    #
    # @example
    #   hidden_field(:user_id, :id => "user_identity")
    #   # will generate 'user_id', 'user_id_element' and 'user_id?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a hidden field.  The valid keys are:
    #   * :class
    #   * :css
    #   * :id
    #   * :index
    #   * :name
    #   * :tag_name
    #   * :text
    #   * :xpath
    #   * :value
    #
    def hidden_field(name, identifier=nil, &block)
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        hidden_field_for(identifier.clone)
        # block ? call_block(&block) : hidden_field_for(identifier.clone)
      end
      define_method(name) do
        return hidden_field_value_for identifier.clone unless block_given?
        self.send("#{name}_element").value
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        hidden_field_for(identifier.clone).exist?
      end
      alias_method "#{name}_hidden_field".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text from a list item,
    # another to return the list item element, and another to check the list item's
    # existence.
    #
    # @example
    #   list_item(:item_one, :id => 'one')
    #   # will generate 'item_one', 'item_one_element', and 'item_one?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a list item.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :xpath
    #   * :name
    #
    def list_item(name, identifier=nil, &block)
      define_method(name) do
        return list_item_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        list_item_for(identifier.clone)
        # block ? call_block(&block) : list_item_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        list_item_for(identifier.clone).exist?
      end
      alias_method "#{name}_list_item".to_sym, "#{name}_element".to_sym
    end

    #
    # adds two methods - one to retrieve the ordered list element, and another to
    # test it's existence.
    #
    # @example
    #   ordered_list(:top_five, :id => 'top')
    #   # will generate 'top_five_element' and 'top_five?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find an ordered list.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :xpath
    #   * :name
    #
    def ordered_list(name, identifier=nil, &block)
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        ordered_list_for(identifier.clone)
        # block ? call_block(&block) : ordered_list_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        ordered_list_for(identifier.clone).exist?
      end
      alias_method "#{name}_ordered_list".to_sym, "#{name}_element".to_sym
    end

    #
    # adds four methods to the page object - one to set text in a text area,
    # another to retrieve text from a text area, another to return the text
    # area element, and another to check the text area's existence.
    #
    # @example
    #   text_area(:address, :id => "address")
    #   # will generate 'address', 'address=', 'address_element',
    #   # 'address?' methods
    #
    # @param  [String] the name used for the generated methods
    # @param [Hash] identifier how we find a text area.  The valid keys are:
    #   * :class
    #   * :css
    #   * :id
    #   * :index
    #   * :name
    #   * :tag_name
    #   * :xpath
    #
    def text_area(name, identifier=nil, &block)
      define_method("#{name}=") do |value|
        return text_area_value_set(identifier.clone, value) unless block_given?
        self.send("#{name}_element").value = value
      end
      define_method(name) do
        return text_area_value_for identifier.clone unless block_given?
        self.send("#{name}_element").value
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        text_area_for(identifier.clone)
        # block ? call_block(&block) : text_area_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        text_area_for(identifier.clone).exist?
      end
      alias_method "#{name}_text_area".to_sym, "#{name}_element".to_sym
    end

    #
    # adds two methods - one to retrieve the unordered list element, and another to
    # check it's existence.
    #
    # @example
    #   unordered_list(:menu, :id => 'main_menu')
    #   # will generate 'menu_element' and 'menu?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find an unordered list.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :xpath
    #   * :name
    #
    def unordered_list(name, identifier=nil, &block)
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        unordered_list_for(identifier.clone)
        # block ? call_block(&block) : unordered_list_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        unordered_list_for(identifier.clone).exist?
      end
      alias_method "#{name}_unordered_list".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text of a h1 element, another to
    # retrieve a h1 element, and another to check for it's existence.
    #
    # @example
    #   h1(:title, :id => 'title')
    #   # will generate 'title', 'title_element', and 'title?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a H1.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def h1(name, identifier=nil, &block)
      define_method(name) do
        return h1_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        h1_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        h1_for(identifier.clone).exist?
      end
      alias_method "#{name}_h1".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text of a h2 element, another
    # to retrieve a h2 element, and another to check for it's existence.
    #
    # @example
    #   h2(:title, :id => 'title')
    #   # will generate 'title', 'title_element', and 'title?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a H2.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def h2(name, identifier=nil, &block)
      define_method(name) do
        return h2_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        h2_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        h2_for(identifier.clone).exist?
      end
      alias_method "#{name}_h2".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text of a h3 element,
    # another to return a h3 element, and another to check for it's existence.
    #
    # @example
    #   h3(:title, :id => 'title')
    #   # will generate 'title', 'title_element', and 'title?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a H3.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def h3(name, identifier=nil, &block)
      define_method(name) do
        return h3_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        h3_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        h3_for(identifier.clone).exist?
      end
      alias_method "#{name}_h3".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text of a h4 element,
    # another to return a h4 element, and another to check for it's existence.
    #
    # @example
    #   h4(:title, :id => 'title')
    #   # will generate 'title', 'title_element', and 'title?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a H4.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def h4(name, identifier=nil, &block)
      define_method(name) do
        return h4_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        h4_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        h4_for(identifier.clone).exist?
      end
      alias_method "#{name}_h4".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text of a h5 element,
    # another to return a h5 element, and another to check for it's existence.
    #
    # @example
    #   h5(:title, :id => 'title')
    #   # will generate 'title', 'title_element', and 'title?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a H5.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def h5(name, identifier=nil, &block)
      define_method(name) do
        return h5_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        h5_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        h5_for(identifier.clone).exist?
      end
      alias_method "#{name}_h5".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text of a h6 element,
    # another to return a h6 element, and another to check for it's existence.
    #
    # @example
    #   h6(:title, :id => 'title')
    #   # will generate 'title', 'title_element', and 'title?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a H6.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def h6(name, identifier=nil, &block)
      define_method(name) do
        return h6_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        h6_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        h6_for(identifier.clone).exist?
      end
      alias_method "#{name}_h6".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to retrieve the text of a paragraph, another
    # to retrieve a paragraph element, and another to check the paragraph's existence.
    #
    # @example
    #   paragraph(:title, :id => 'title')
    #   # will generate 'title', 'title_element', and 'title?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a paragraph.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def paragraph(name, identifier=nil, &block)
      define_method(name) do
        return paragraph_text_for identifier.clone unless block_given?
        self.send("#{name}_element").text
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        paragraph_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        paragraph_for(identifier.clone).exist?
      end
      alias_method "#{name}_paragraph".to_sym, "#{name}_element".to_sym
    end

    #
    # adds three methods - one to set the file for a file field, another to retrieve
    # the file field element, and another to check it's existence.
    #
    # @example
    #   file_field(:the_file, :id => 'file_to_upload')
    #   # will generate 'the_file=', 'the_file_element', and 'the_file?' methods
    #
    # @param [String] the name used for the generated methods
    # @param [Hash] identifier how we find a file_field.  You can use a multiple paramaters
    #   by combining of any of the following except xpath.  The valid keys are:
    #   * :class
    #   * :id
    #   * :index
    #   * :name
    #   * :title
    #   * :xpath
    # @param optional block to be invoked when element method is called
    #
    def file_field(name, identifier=nil, &block)
      define_method("#{name}=") do |value|
        return file_field_value_set(identifier.clone, value) unless block_given?
        self.send("#{name}_element").value = value
      end
      define_method("#{name}_element") do
        return call_block(&block) if block_given?
        file_field_for(identifier.clone)
      end
      define_method("#{name}?") do
        return call_block(&block) if block_given?
        file_field_for(identifier.clone).exist?
      end
    end
  end
end
