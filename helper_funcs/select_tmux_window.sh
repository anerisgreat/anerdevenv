windows=$(tmux list-windows -a | cut -d ':' -f 2)
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

preMsg="Window number ('x' to cancel)"
while [ "$foundWindow" != "$nextWindow" ] && [ "$nextWindow" != "x" ]
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
                preMsg="Invalid ('x' to cancel)"
                break
            else
                #If hit enter after a character has been entered, good enough
                break
            fi
        fi

        #If canceled with x
        if [ $lastChar = "x" ]
        then
            nextWindow=$lastChar
            break
        fi

        #Checking if it is number, if not redo
        re='^[0-9]+$'
        if ! [[ $nextWindow =~ $re ]] ; then
            preMsg="Invalid ('x' to cancel)"
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

        tmp=$(echo $trimmedWindows | grep -wo $nextWindow)
        if [ "$tmp" = "$nextWindow" ] || [ -z "$tmp" ] 
        then
            break
        fi
    done

    #Trim leading zeros
    nextWindow=$(echo $nextWindow | sed 's/^0*//')
    #If all was 0s, number must have been 0
    if [ -z "$nextWindow" ]
    then
        nextWindow=0
    fi
    #Find window matching whole word
    foundWindow=$(echo $windows | grep -wo $nextWindow)
done
source ./clear_tmux_display.sh
echo $nextWindow
