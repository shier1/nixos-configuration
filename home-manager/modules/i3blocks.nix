{config, pkgs, ...}:

{
  home.file = {
    "cpu_usage.sh" = {
      text = ''
        use strict;
        use warnings;
        use utf8;
        use Getopt::Long;

        # default values
        my $t_warn = $ENV{T_WARN} // 50;
        my $t_crit = $ENV{T_CRIT} // 80;
        my $cpu_usage = -1;
        my $decimals = $ENV{DECIMALS} // 2;
        my $label = $ENV{LABEL} // "";
        my $color_normal = $ENV{COLOR_NORMAL} // "#EBDBB2";
        my $color_warn = $ENV{COLOR_WARN} // "#FFFC00";
        my $color_crit = $ENV{COLOR_CRIT} // "#FF0000";

        sub help {
            print "Usage: cpu_usage [-w <warning>] [-c <critical>] [-d <decimals>]\n";
            print "-w <percent>: warning threshold to become yellow\n";
            print "-c <percent>: critical threshold to become red\n";
            print "-d <decimals>:  Use <decimals> decimals for percentage (default is $decimals) \n"; 
            exit 0;
        }

        GetOptions("help|h" => \&help,
                  "w=i"    => \$t_warn,
                  "c=i"    => \$t_crit,
                  "d=i"    => \$decimals,
        );

        # Get CPU usage
        $ENV{LC_ALL}="en_US"; # if mpstat is not run under en_US locale, things may break, so make sure it is
        open (MPSTAT, 'mpstat 1 1 |') or die;
        while (<MPSTAT>) {
            if (/^.*\s+(\d+\.\d+)[\s\x00]?$/) {
                $cpu_usage = 100 - $1; # 100% - %idle
                last;
            }
        }
        close(MPSTAT);

        $cpu_usage eq -1 and die 'Can\'t find CPU information';

        # Print short_text, full_text
        print "${label}";
        printf "%.${decimals}f%%\n", $cpu_usage;
        print "${label}";
        printf "%.${decimals}f%%\n", $cpu_usage;

        # Print color, if needed
        if ($cpu_usage >= $t_crit) {
            print "${color_crit}\n";
        } elsif ($cpu_usage >= $t_warn) {
            print "${color_warn}\n";
        } else {
            print "${color_normal}\n";
        }

        exit 0;
      '';
      executable = true;
    };
  };
  programs.i3blocks = {
    enable = true;
    bars = {
      config = {
        title = {
          interval = "persist";
          command = "${pkgs.xtitle}/bin/xtitle -s";
          format = " {title}";
          color = "#F8F8F2";
          max_width = 200;
        };
        time = {
          command = "date '+%H:%M'";
          interval = 60;
          format = " {time}";
          color = "#FFFFFF";
          background = "#6272A4";
        };
        date = lib.hm.dag.entryAfter [ "time" ] {
          command = "date '+%Y-%m-%d'";
          interval = 300;
          format = " {date}";
          color = "#F8F8F2";
        };
        systray = lib.hm.dag.entryAfter [ "date" ] {
          command = "echo ''";
          interval = "persist";
          color = "#FF79C6";
        };
      };
    };
  };
}