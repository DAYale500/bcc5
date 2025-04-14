generic run command
flutter run >> BCC4_logs.txt 2>&1

-------------------------------------------------------------------------------------------------------------------------

simulator, run command

alias runsim='flutter run -d "iPhone 13" >> ZZ_BCC5_logs.txt 2>&1'

runsim=$'gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \\\n  | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \\\n  | perl -pe "s/\\\\\\\\\\\\^\\\\[\\\\[[0-9;]+m//g" \\\n  | sed -E "s/^[[:space:]]*│[[:space:]]*//" \\\n  | grep -vE "^[┌├└]" \\\n  | awk \'{ printf "[%04d] %s\\n", NR, $0 }\' \\\n  | tee ZZ_BCC5_logs.txt'


runsim

runsim() {
  gstdbuf -oL flutter run -d 3A04C62A-C78C-4470-A174-DD9285589BCA 2>&1 \
    | sed -E "s/^[[:space:]]*flutter:[[:space:]]*//" \
    | perl -pe "s/\x1B\[[0-9;]*m//g" \
    | sed -E "s/^[[:space:]]*│[[:space:]]*//" \
    | grep -vE "^[┌├└]" \
    | awk '{ printf "[%04d] %s\n", NR, $0 }' \
    > ZZ_BCC5_logs.txt
}



-------------------------------------------------------------------------------------------------------------------------


physical iPhone one command

runphone

echo 'alias runphone="flutter run -d 00008110-001E41122183801E >> ZZ_BCC4_z_logs.txt 2>&1"' >> ~/.zshrc



-------------------------------------------------------------------------------------------------------------------------

OOutput files -all at once - (run from bcc4):

file_away

timestamp=$(date +"%Y%m%d_%H%M%S") && \
tree lib -a -I ".*" > "Z_bcc4_file_structure_${timestamp}.txt" && \
find lib -type f -path "lib/data/repositories/*" -not -name ".*" -exec sh -c 'echo -e "\n\n\n\n\n\n\n\n\n\nFile: {}" >> "Z_bcc4_repositories_'"${timestamp}"'.txt" && cat "{}" >> "Z_bcc4_repositories_'"${timestamp}"'.txt"' \; && \
find lib -type f -not -path "lib/data/repositories/*" -not -name ".*" -exec sh -c 'echo -e "\n\n\n\n\n\n\n\n\n\nFile: {}" >> "Z_bcc4_all_others_'"${timestamp}"'.txt" && cat "{}" >> "Z_bcc4_all_others_'"${timestamp}"'.txt"' \;


-------------------------------------------------------------------------------------------------------------------------



Run flutter clean to remove old build files.
Run flutter pub get to fetch dependencies.
Run runsim (which starts the iPhone simulator).
echo 'alias reset_app="flutter clean && flutter pub get && runsim"' >> ~/.zshrc && source ~/.zshrc

reset_app


start Ollama (in terminal)
ollama serve
