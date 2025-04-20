# alias runsim='gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \
#   | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \
#   | perl -pe "s/\\\\\\^\\[\\[[0-9;]+m//g" \
#   | sed -E "s/^[[:space:]]*│[[:space:]]*//" \
#   | grep -vE "^[┌├└]" \
#   | awk '\''{ printf "[%04d] %s\n", NR, $0 }'\'' \
#   | tee ZZ_BCC5_logs.txt'

# runsim=$'gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \\
#   | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \\
#   | perl -pe "s/\\\\\\\\\\\\^\\\\[\\\\[[0-9;]+m//g" \\
#   | sed -E "s/^[[:space:]]*│[[:space:]]*//" \\
#   | grep -vE "^[┌├└]" \\
#   | awk \'{ printf "[%04d] %s\\n", NR, $0 }\' \\
#   > ZZ_BCC5_logs.txt'

# alias runsim='gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \
#   | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \
#   | perl -pe "s/\\x1B\\[[0-9;]*m//g" \
#   | sed -E "s/^[[:space:]]*│[[:space:]]*//" \
#   | grep -vE "^[┌├└]" \
#   | awk '\''{ printf "[%04d] %s\n", NR, $0 }'\'' \
#   | tee ZZ_BCC5_logs.txt'

# runsim() {
#   gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \
#     | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \
#     | perl -pe "s/\x1B\[[0-9;]*m//g" \
#     | sed -E "s/^[[:space:]]*│[[:space:]]*//" \
#     | grep -vE "^[┌├└]" \
#     | awk '{ printf "[%04d] %s\n", NR, $0 }' \
#     > ZZ_BCC5_logs.txt
# }

unalias runsim 2>/dev/null


# runsim() {
#   flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \
#     | perl -pe 's/\x1B\[[0-9;]*m//g' \
#     | grep -vE '^[┌├└│]+$' \
#     | grep -vE '^(\s*[┌├└])' \
#     | awk '{ printf "[%04d] %s\n", NR, $0 }' \
#     > ZZ_BCC5_logs.txt
# }




# runsim() {
#   LOG_FILE="ZZ_BCC5_logs.txt"
#   DEVICE_ID="3A04C62A-C78C-4470-A174-DD9285589BCA"

#   # Clear the log file
#   > "$LOG_FILE"

#   # Run Flutter and process output
#   # add gstdbuf -oL to flush if needed
#   flutter run -d "$DEVICE_ID" 2>&1 | \
#     perl -pe 's/\x1B\[[0-9;]*m//g' | \                             # Strip ANSI codes
#     grep -vE '^[\s│├└┌─┬┼┐┘┤┬┴┼═║╔╗╚╝╠╣╦╩╬]+$' | \                 # Remove box characters
#     awk '{ printf "[%04d] %s\n", NR, $0 }' \                       # Line numbering
#     > "$LOG_FILE"
# }


# runsim() {
#   LOG_FILE="ZZ_BCC5_logs.txt"
#   DEVICE_ID="3A04C62A-C78C-4470-A174-DD9285589BCA"

#   # Clear the log file
#   > "$LOG_FILE"

#   # Run Flutter and process output
#   # add gstdbuf -oL to flush if needed
#   flutter run -d "$DEVICE_ID" 2>&1 | \
#     perl -pe 's/\x1B\[[0-9;]*m//g' | \                             # Strip ANSI codes
#     grep -vE '^[\s│├└┌─┬┼┐┘┤┬┴┼═║╔╗╚╝╠╣╦╩╬]+$' | \                 # Remove box characters
#     awk '{ printf "[%04d] %s\n", NR, $0 }' \                       # Line numbering
#     > "$LOG_FILE"
# }



# runsim() {
#   LOG_FILE="ZZ_BCC5_logs.txt"
#   DEVICE_ID="3A04C62A-C78C-4470-A174-DD9285589BCA"

#   # Clear previous log
#   > "$LOG_FILE"
#   echo -e "\n\n=== NEW RUN $(date) ===\n" > "$LOG_FILE"

#   # Start Flutter run and background log cleaner
#   flutter run -d "$DEVICE_ID" 2>&1 | \
#     perl -pe 's/\x1B\[[0-9;]*m//g' | \                                  # Strip ANSI
#     grep -vE '^[\s│├└┌─┬┼┐┘┤┬┴┼═║╔╗╚╝╠╣╦╩╬]+$' | \                      # Box characters
#     awk '{ printf "[%04d] %s\n", NR, $0 }' \                            # Line numbers
#     > "$LOG_FILE" &

#   # Hide terminal output to prevent clutter
#   disown
# }