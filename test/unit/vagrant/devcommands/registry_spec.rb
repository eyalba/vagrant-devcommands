require_relative '../../spec_helper'

describe VagrantPlugins::DevCommands::Registry do
  commandfile = VagrantPlugins::DevCommands::CommandFile

  describe 'command definition' do
    before :context do
      @olddir = Dir.pwd
      @newdir = File.join(File.dirname(__FILE__),
                          '../../fixtures/simple-commandfile')

      Dir.chdir @newdir

      @env = Vagrant::Environment.new(cwd: @newdir)
    end

    it 'allows defining commands' do
      file     = commandfile.new(@env)
      registry = described_class.new(@env)

      registry.read_commandfile(file)

      expect(registry.commands['foo'].script).to eq('foo')
      expect(registry.commands['bar'].script).to eq('bar')
    end

    it 'auto registers the commands name' do
      file     = commandfile.new(@env)
      registry = described_class.new(@env)

      registry.read_commandfile(file)

      expect(registry.commands['foo'].name).to eq('foo')
      expect(registry.commands['bar'].name).to eq('bar')
    end

    it 'detects invalid commands' do
      file     = commandfile.new(@env)
      registry = described_class.new(@env)

      registry.read_commandfile(file)

      expect(registry.valid_command?('foo')).to be true
      expect(registry.valid_command?('xxx')).to be false
    end

    after :context do
      Dir.chdir(@olddir)
    end
  end

  describe 'defining reserved commands' do
    before :context do
      @olddir = Dir.pwd
      @newdir = File.join(File.dirname(__FILE__),
                          '../../fixtures/reserved-commands')

      Dir.chdir @newdir

      @env = Vagrant::Environment.new(
        cwd:      @newdir,
        ui_class: Helpers::UI::Tangible
      )
    end

    it 'displays a message' do
      file     = commandfile.new(@env)
      registry = described_class.new(@env)

      registry.read_commandfile(file)

      messages = @env.ui.messages.map { |m| m[:message] }.join("\n")

      described_class::RESERVED_COMMANDS.each do |command|
        expect(messages).to match(/#{command}.+reserved/i)
      end
    end

    after :context do
      Dir.chdir(@olddir)
    end
  end

  describe 'defining without command script' do
    before :context do
      @olddir = Dir.pwd
      @newdir = File.join(File.dirname(__FILE__),
                          '../../fixtures/missing-script')

      Dir.chdir @newdir

      @env = Vagrant::Environment.new(
        cwd:      @newdir,
        ui_class: Helpers::UI::Tangible
      )
    end

    it 'displays a message' do
      file     = commandfile.new(@env)
      command  = 'no_script_cmd'
      registry = described_class.new(@env)

      registry.read_commandfile(file)

      expect(@env.ui.messages[0][:message]).to match(/#{command}.+no script/i)
      expect(registry.valid_command?(command)).to be(false)
    end

    after :context do
      Dir.chdir(@olddir)
    end
  end

  describe 'validating a reserved command' do
    it 'always returns true' do
      registry = described_class.new(nil)

      described_class::RESERVED_COMMANDS.each do |name|
        expect(registry.valid_command?(name)).to be true
      end
    end
  end
end
