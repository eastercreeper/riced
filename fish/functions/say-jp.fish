function say-jp
    if test (count $argv) -eq 0
        echo "Usage: say-jp text"
        return 1
    end

    set text (string join ' ' -- $argv)
    set speaker 3
    set query (mktemp --suffix=.json)
    set wav (mktemp --suffix=.wav)

    # Create the audio query
    set status_code (curl -sS \
        -o $query \
        -w '%{http_code}' \
        -X POST \
        "http://127.0.0.1:50021/audio_query?speaker=$speaker" \
        --get \
        --data-urlencode "text=$text")

    if test "$status_code" != 200
        echo "VOICEVOX audio_query failed. HTTP status: $status_code"
        cat $query
        rm -f $query $wav
        return 1
    end

    # Generate WAV audio
    set status_code (curl -sS \
        -o $wav \
        -w '%{http_code}' \
        -X POST \
        -H "Content-Type: application/json" \
        -d @$query \
        "http://127.0.0.1:50021/synthesis?speaker=$speaker")

    if test "$status_code" != 200
        echo "VOICEVOX synthesis failed. HTTP status: $status_code"
        cat $wav
        rm -f $query $wav
        return 1
    end

    if not test -s $wav
        echo "VOICEVOX created an empty audio file."
        rm -f $query $wav
        return 1
    end

    paplay --device=tts_sink $wav
    set play_status $status

    rm -f $query $wav
    return $play_status
end
