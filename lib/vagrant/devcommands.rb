require 'locale'
require 'vagrant'

I18n.load_path << File.expand_path('../../../locales/de.yml', __FILE__)
I18n.load_path << File.expand_path('../../../locales/en.yml', __FILE__)
I18n.reload!

I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)

I18n.default_locale = :en
I18n.locale         = Locale.candidates[0].language.to_sym

require 'vagrant/devcommands/synopsis'
require 'vagrant/devcommands/version'

require 'vagrant/devcommands/internal_spec'
require 'vagrant/devcommands/messages'
require 'vagrant/devcommands/util'

require 'vagrant/devcommands/model/chain'
require 'vagrant/devcommands/model/command'

require 'vagrant/devcommands/help_printer/chain'
require 'vagrant/devcommands/help_printer/command'
require 'vagrant/devcommands/internal_command/help'
require 'vagrant/devcommands/internal_command/version'

require 'vagrant/devcommands/command'
require 'vagrant/devcommands/command_file'
require 'vagrant/devcommands/internal'
require 'vagrant/devcommands/plugin'
require 'vagrant/devcommands/registry'
