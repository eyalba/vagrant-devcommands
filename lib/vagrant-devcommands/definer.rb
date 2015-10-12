module VagrantPlugins
  module DevCommands
    class Definer

      @@commands = {}


      def self.commands
        @@commands
      end

      def self.define(name, options)
        if options.kind_of?(String)
          @@commands[name] = { command: options }
        else
          @@commands[name] = options
        end
      end

    end
  end
end
