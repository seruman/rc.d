function fish_venv_prompt --description 'Show virtual environment status'
    if set -q VIRTUAL_ENV
        echo -n ".venv "
    end
end

function format_duration --description 'Format duration ms in human readable way'
    set -l milliseconds $argv[1]
    
    set -l total_seconds (math --scale=0 "$milliseconds / 1000")
    set -l total_minutes (math --scale=0 "$total_seconds / 60")
    set -l total_hours (math --scale=0 "$total_minutes / 60")
    set -l total_days (math --scale=0 "$total_hours / 24")

    set -l parts

    if test $total_days -gt 0
        set -l remaining_hours (math --scale=0 "$total_hours % 24")
        set -l remaining_minutes (math --scale=0 "$total_minutes % 60")
        set -l remaining_seconds (math --scale=0 "$total_seconds % 60")

        set -a parts $total_days"d"
        
        if test $remaining_hours -gt 0
            set -a parts $remaining_hours"h"
        end
        
        if test $remaining_minutes -gt 0
            set -a parts $remaining_minutes"m"
        end
        
        if test $remaining_seconds -gt 0
            set -a parts $remaining_seconds"s"
        end
    else
        if test $total_hours -gt 0
            set -l remaining_minutes (math --scale=0 "$total_minutes % 60")
            set -l remaining_seconds (math --scale=0 "$total_seconds % 60")

            set -a parts $total_hours"h"
            
            if test $remaining_minutes -gt 0
                set -a parts $remaining_minutes"m"
            end
            
            if test $remaining_seconds -gt 0
                set -a parts $remaining_seconds"s"
            end
        else
            if test $total_minutes -gt 0
                set -l remaining_seconds (math --scale=0 "$total_seconds % 60")

                set -a parts $total_minutes"m"
                
                if test $remaining_seconds -gt 0
                    set -a parts $remaining_seconds"s"
                end
            else
                set -a parts $total_seconds"s"
            end
        end
    end

    string join " " $parts
end

function fish_duration_prompt --description 'Show command duration'
    if test $CMD_DURATION -gt 5000
        echo -n " " (set_color yellow)(format_duration $CMD_DURATION)(set_color normal)
    end
end

function prompt_char --argument char --description 'Color prompt character based on status'
    set -l last_status $status
    if test $last_status -eq 0
        echo -n (set_color green)$char(set_color normal)
    else
        echo -n (set_color red)$char(set_color normal)
    end
end

function fish_prompt --description 'Two-line prompt'
    set -l pwd_part (set_color blue)(prompt_pwd -d 200)(set_color normal)
    set -l vcs_part (fish_vcs_prompt)
    set -l duration_part (fish_duration_prompt)
    set -l venv_part (fish_venv_prompt)
    set -l prompt_part (prompt_char ";")

    echo -s $pwd_part $vcs_part $duration_part \n $venv_part $prompt_part " "
end
