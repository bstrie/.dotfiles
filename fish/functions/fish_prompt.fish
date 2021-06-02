function set_bg
    set_color -b $argv[1]
    set prior_bg $argv[1]
end

function next_bg
    set_color $prior_bg
    set_bg $argv[1]
    echo -n ''
end

# Adapted from fish_git_prompt
function git_prompt
    set -l repo_info (command git rev-parse --git-dir --is-inside-work-tree HEAD 2>/dev/null)
    test -n "$repo_info"
    or return # not in a repo or git not present

    set -l git_dir $repo_info[1]
    set -l inside_worktree $repo_info[2]
    set -l sha $repo_info[3]

    test true = $inside_worktree
    or return # inside .git folder

    set -l branch
    set -l operation
    set -l step
    set -l total

    if test -d $git_dir/rebase-merge
        set branch (cat $git_dir/rebase-merge/head-name 2>/dev/null)
        set operation "rebasing"
        set step (cat $git_dir/rebase-merge/msgnum 2>/dev/null)
        set total (cat $git_dir/rebase-merge/end 2>/dev/null)
    else
        if test -d $git_dir/rebase-apply
            if test -f $git_dir/rebase-apply/rebasing
                set branch (cat $git_dir/rebase-apply/head-name 2>/dev/null)
                set operation "rebasing"
            else if test -f $git_dir/rebase-apply/applying
                set operation "applying"
            end
            set step (cat $git_dir/rebase-apply/next 2>/dev/null)
            set total (cat $git_dir/rebase-apply/last 2>/dev/null)
        else if test -f $git_dir/MERGE_HEAD
            set operation "merging"
        else if test -f $git_dir/CHERRY_PICK_HEAD
            set operation "cherry-picking"
        else if test -f $git_dir/REVERT_HEAD
            set operation "reverting"
        else if test -f $git_dir/BISECT_LOG
            set operation "bisecting"
        end
    end

    if test -n "$step" -a -n "$total"
        set operation "$operation $step/$total"
    end

    if test -z "$branch"
        if not set branch (command git symbolic-ref HEAD 2>/dev/null)
            if set -q sha
                set branch (string sub -l 8 $sha)
            else
                set branch unknown
            end
            set branch "[$branch]"
        end
    end

    set branch (string replace refs/heads/ '' -- $branch)

    set -l dirty
    set -l staged
    set -l untracked

    if not test "$sha" = "HEAD"
        if not command git diff-index --cached --quiet HEAD 2> /dev/null
            set staged '𝛴'
        end
        if not command git diff-index --ignore-submodules=dirty --quiet HEAD 2> /dev/null
            set dirty '𝛥'
        end
    else # repo with no commits
        if not command git diff --cached --quiet 2> /dev/null
            set staged '𝛴'
        end
    end

    if command git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- :/ >/dev/null 2>&1
        set untracked '𝛸'
    end

    echo $branch
    echo "$staged$dirty$untracked"
    echo $operation
end

function fish_prompt
    # Capture the last status before we mess it up
    set -l last_status $status

    # Determine the moon phase
    switch $moon_phase
        case 🌑
            set moon_phase 🌒
        case 🌒
            set moon_phase 🌓
        case 🌓
            set moon_phase 🌔
        case 🌔
            set moon_phase 🌕
        case 🌕
            set moon_phase 🌖
        case 🌖
            set moon_phase 🌗
        case 🌗
            set moon_phase 🌘
        case 🌘
            set moon_phase 🌑
    end

    echo # separate from previous output

    set_bg $blackplus
    echo -n ' '

    if set -q SSH_TTY
        set_color brgreen
        echo -n "$USER@$host"
        set_color white
        echo -n ':'
    end

    set_color brblue
    echo -n (string replace -r "^$HOME(/|\$)" '~$1' $PWD)' '

    set -l git_info (git_prompt)
    if set -q git_info[1]
        next_bg brblack
        set_color brcyan
        echo -n " $git_info[1] "
        if test -n $git_info[2]
            next_bg $brblackplus
            set_color brmagenta
            echo -n " $git_info[2] "
        end
        if test -n $git_info[3]
            next_bg white
            set_color black
            echo -n " $git_info[3] "
        end
    end

    next_bg black

    if not test $last_status -eq 0
        set_color red
    else
        set_color brwhite
    end

    echo

    echo -n "$moon_phase "

    set_color normal
end
