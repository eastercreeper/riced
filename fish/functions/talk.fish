function talk
    echo "Japanese TTS mode enabled. Type text and press Enter."
    echo "Press Ctrl+D or Ctrl+C to exit."

    while true
        read -P "tts> " text

        if test $status -ne 0
            break
        end

        if test -z "$text"
            continue
        end

        say-jp "$text"
    end

    echo
    echo "TTS mode ended."
end
