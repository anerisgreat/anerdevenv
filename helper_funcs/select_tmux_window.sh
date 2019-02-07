session=$(tmux display-message -p "#S")
windows=$(tmux list-windows -t 0 -a | grep "^$session:" | cut -d ':' -f 2)
windows+=" "
longest=0
for word in $windows
do
    len=${#word}
    if (( len > longest))
    then
        longest=$len
    fi
done

lastChar=U
foundWindow=A
nextWindow=B

preMsg="Window number ('n' to cancel)"
while [ "$foundWindow" != "$nextWindow" ] && [ "$nextWindow" != "n" ]
do
    nextWindow=""
    #We want to capture X characters, corresponding to string length of
    #Largest window number
    for (( i=1 ; i<=$longest ; i++ ))
    do
        message="$preMsg: $nextWindow"
        source ./set_tmux_display.sh "$message"
        read -rsn1 lastChar
        nextWindow="$nextWindow$lastChar"

        #If hit enter, string is empty
        if [ -z "$lastChar" ]
        then
            if (($i == 1))
            then
                #If hit enter before entering character, run again
                nextWindow=REDO
                preMsg="Invalid ('n' to cancel)"
                break
            else
                #If hit enter after a character has been entered, good enough
                break
            fi
        fi

        #If canceled with n
        if [ $lastChar = "n" ]
        then
            nextWindow=$lastChar
            break
        fi

        #Checking if it is number, if not redo
        re='^[0-9]+$'
        if ! [[ $nextWindow =~ $re ]] ; then
            preMsg="Invalid ('n' to cancel)"
            nextWindow=REDO
            break
        fi

        #Matching characters to windows, in case no more chars are needed
        trimmedWindows=""
        for word in $windows
        do
            trimmedWindows+=$(echo $word | head -c $i)
            trimmedWindows+=" "
        done

        tmp=$(echo $trimmeds | grep -wo $nextWindow)
        if [ "$tmp" = "$nextWindow" ] || [ -z "$tmp" ] 
        then
            break
        fi
    done

    #Find window matching whole word
    foundWindow=$(echo $windows | grep -wo $nextWindow)
done
source ./clear_tmux_display.sh
echo $nextWindow
