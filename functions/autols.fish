function autols -d "Interact with autols.fish"
    set -l options h/help
    if test (count $argv) -eq 0
        # If not subcommand is given use `status` as default
        set argv status
    end

    if not argparse $options -- $argv
        eval (status function) --help
        return 2
    end

    set -l reset (set_color normal)
    set -l red (set_color red)
    set -l green (set_color green)
    if set --query _flag_help
        set -l blue (set_color blue)
        set -l yellow (set_color yellow)
        set -l bold (set_color --bold)
        set -l option_color (set_color $fish_color_option)
        set -l param_color (set_color $fish_color_param)

        printf "%sInteract with autols.fish%s\n" $bold $reset >&2
        printf "\n" >&2
        printf "%sUSAGE%s\n" $yellow $reset >&2
        printf "\t%s%s%s <command> [options]\n" (set_color $fish_color_command) (status function) $reset >&2
        printf "\n" >&2
        printf "%sCOMMANDS%s\n" $yellow $reset >&2
        printf "\t%sstatus%s\treturns 0 if autols.fish is enabled, 1 otherwise\n" $param_color $reset >&2
        printf "\t%son%s\t%senables%s autols.fish\n" $param_color $reset $green $reset >&2
        printf "\t%soff%s\t%sdisables%s autols.fish\n" $param_color $reset $red $reset >&2
        printf "\t%stoggle%s\ttoggles autols.fish between on and off\n" $param_color $reset >&2
        printf "\n" >&2
        printf "%sOPTIONS%s\n" $yellow $reset >&2
        printf "\t%s-h%s, %s--help%s\tShow this help message and exit\n" $option_color $reset $option_color $reset >&2

    set -l github_url https://github.com/kpbaks/autols.fish
    set -l star_symbol ⭐
    set -l magenta (set_color magenta)
    printf "\n" >&2
    printf "Part of %sautols.fish%s. A plugin for the %s><>%s shell.\n" $magenta $reset $blue $reset >&2
    printf "See %s%s%s for more information, and if you like it, please give it a %s\n" (set_color --underline cyan) $github_url $reset $star_symbol >&2

        return 0
    end

    switch $argv[1]
        case status
            if set --query AUTOLS_FISH_DISABLED
                printf "%sdisabled%s\n" $red $reset >&2
                return 1
            else
                printf "%senabled%s\n" $green $reset >&2
                return 0
            end

        case on
            if set --query AUTOLS_FISH_DISABLED
                set --erase AUTOLS_FISH_DISABLED
                printf "%senabling%s\n" $green $reset >&2
            end
            # echo already enabled
            # set -l f $__fish_config_dir/conf.d/autols.fish
            # test -f $f; and source $f
        case off
            if not set --query AUTOLS_FISH_DISABLED
                # Use --universal scope, such that the change affect all running fish interactive sessions, 
                # and so that the change is persisted, when the session eventually ends.
                set --universal AUTOLS_FISH_DISABLED
                printf "%sdisabling%s\n" $red $reset >&2
            else
                # echo already disabled
            end
        case toggle
            if set --query AUTOLS_FISH_DISABLED
                eval (status function) on
            else
                eval (status function) off
            end
    end
end