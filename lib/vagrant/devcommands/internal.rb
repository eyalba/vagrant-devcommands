module VagrantPlugins
  module DevCommands
    # Handles internal commands and their execution.
    class Internal
      NAMESPACE_CMD  = VagrantPlugins::DevCommands::InternalCommand
      NAMESPACE_SPEC = VagrantPlugins::DevCommands::InternalSpec

      COMMANDS = {
        'help'    => CommandDef.new(NAMESPACE_SPEC::HELP),
        'version' => CommandDef.new(NAMESPACE_SPEC::VERSION)
      }.freeze

      def initialize(env, registry)
        @internal = {
          'help'    => NAMESPACE_CMD::Help.new(env, registry),
          'version' => NAMESPACE_CMD::Version.new(env)
        }
        @registry = registry
      end

      def run(command, args)
        @internal[command].execute(args) if @internal.key?(command)
      end
    end
  end
end
