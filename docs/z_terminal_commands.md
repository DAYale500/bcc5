generic run command
flutter run >> BCC4_logs.txt 2>&1

-------------------------------------------------------------------------------------------------------------------------

simulator, run command

alias runsim='flutter run -d "iPhone 13" >> ZZ_BCC5_logs.txt 2>&1'

runsim

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
