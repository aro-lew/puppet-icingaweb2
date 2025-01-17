require 'spec_helper'

describe('icingaweb2::module::director', type: :class) do
  let(:pre_condition) do
    [
      "class { 'icingaweb2': }",
    ]
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context "#{os} with kickstart 'true'" do
        let(:params) do
          { git_revision: 'foobar',
            db_host: 'localhost',
            db_name: 'director',
            db_username: 'director',
            db_password: 'director',
            import_schema: true,
            kickstart: true,
            endpoint: 'foobar',
            api_username: 'root',
            api_password: 'secret' }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-director')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('director')
            .with_username('director')
            .with_password('director')
            .with_charset('utf8')
        }

        it {
          is_expected.to contain_icingaweb2__module('director')
            .with_install_method('git')
            .with_git_revision('foobar')
            .with_module_dir('/usr/share/icingaweb2/modules/director')
            .with_settings('module-director-db' => {
                             'section_name' => 'db',
                             'target' => '/etc/icingaweb2/modules/director/config.ini',
                             'settings' => {
                               'resource' => 'icingaweb2-module-director',
                             },
                           },
                           'module-director-config' => {
                             'section_name' => 'config',
                             'target' => '/etc/icingaweb2/modules/director/kickstart.ini',
                             'settings' => {
                               'endpoint' => 'foobar',
                               'host' => 'localhost',
                               'port' => '5665',
                               'username' => 'root',
                               'password' => 'secret',
                             },
                           })
        }

        it { is_expected.to contain_exec('director-migration') }
        it { is_expected.to contain_exec('director-kickstart') }
      end

      context "#{os} with import_schema 'false'" do
        let(:params) do
          { git_revision: 'foobar',
            db_host: 'localhost',
            db_name: 'director',
            db_username: 'director',
            db_password: 'director',
            import_schema: false }
        end

        it {
          is_expected.to contain_icingaweb2__resource__database('icingaweb2-module-director')
            .with_type('mysql')
            .with_host('localhost')
            .with_database('director')
            .with_username('director')
            .with_password('director')
            .with_charset('utf8')
        }

        it {
          is_expected.to contain_icingaweb2__module('director')
            .with_install_method('git')
            .with_git_revision('foobar')
            .with_module_dir('/usr/share/icingaweb2/modules/director')
            .with_settings('module-director-db' => {
                             'section_name' => 'db',
                             'target' => '/etc/icingaweb2/modules/director/config.ini',
                             'settings' => {
                               'resource' => 'icingaweb2-module-director',
                             },
                           })
        }

        it { is_expected.not_to contain_exec('director-migration') }
        it { is_expected.not_to contain_exec('director-kickstart') }
      end
    end
  end
end
