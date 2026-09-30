function say
    if test (count $argv) -eq 0
        echo "Usage: say text to speak"
        return 1
    end

    set wav (mktemp --suffix=.wav)
    set text (string join ' ' -- $argv)

    ~/.venvs/piper/bin/python -m piper \
        --data-dir ~/.local/share/piper-voices \
        -m en_US-lessac-medium \
        -f $wav \
        -- $text

    paplay --device=tts_sink $wav
    rm -f $wav
end
