module Administa
  class Config
    module Menu
      def menus(controller)
        m= Tree.new(&@menu_def)
        m.run(controller).menus
      end

      def menu(&block)
        @menu_def = block
        m = Tree.new(&@menu_def)
        m.run

        self.controllers = m.controllers
      end

      class Tree
        attr_accessor :menus, :controllers

        def initialize(&block)
          @menus      = []
          @controlers = []
          @block      = block
        end

        def run(current_controller = nil)
          @current_controller = current_controller
          self.instance_eval(&@block)
          self
        end

        def t(s, options = {})
          if s.is_a? Symbol
            s = I18n.t(s, scope: options[:scope], default: s)
          end
          return s
        end

        def label(s, options = {})
          @menus.push({
            type: :label,
            label: t(s),
          })
        end

        def group(title, options = {}, &block)
          t = case title
              when String, Symbol then label(title, options)
              else controller(title, options)
          end

          m = Tree.new(&block)
          m.run(@current_controller)

          @controlers += m.controllers.to_a
          children = m.menus
          opened=  children.any?{|h| h[:selected] || h[:opened]}

          @menus.push({
            type:   :group,
            label:  t,
            menus:  children,
            opened: opened,
          })
        end

        def menu(c, options = {})
          @menus.push(controller(c))
        end

        private
        def controller(c, options= {})
          selected = @current_controller.try(:controller_path) == c.controller_path
          @controlers.push(c)
          {
            type:  :menu,
            path:  "/#{c.controller_path}",
            label: c.model.label,
            selected: selected
          }
        end
      end
    end
  end
end
