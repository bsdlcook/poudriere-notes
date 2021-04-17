#####
# Helper functions
function __fish_poudriere_ports_tree
    printf '%s\n' (command poudriere ports -l | sed -n '1!p' | awk '{print $1}')
end

#####
# build-pkg(1)
set -l common_opt -c build-pkg -s
complete $common_opt a --description 'Build all targets listed in the configuration'
complete $common_opt b -r --description 'Comma-delimited list of resulting ports to build'
complete $common_opt c --description 'Configure package before build'
complete $common_opt d -r --description 'Directory containing the ports tree collection'
complete $common_opt h --description 'Displays help page'
complete $common_opt i --description 'Enable interactive shell post-build'
complete $common_opt n --description 'Dry-run, don\'t execute any commands, just output them instead'
complete $common_opt p -r --description 'Comma-delimited list of resulting ports to build'
complete $common_opt s -r --description 'Script to execute post-build'
complete $common_opt t -r --description 'Poudriere ports tree' -a '(__fish_poudriere_ports_tree)'
complete $common_opt u --description 'Bulk build package'
complete $common_opt v --description 'Enable verbose mode. Prints the running build phase'
