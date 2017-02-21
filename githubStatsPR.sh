#!/bin/bash 

owner=${2:-Wallapop}
repo=${1:-WallapopBackend}
page=${3:-}
 
 
function listPRsWithStats {

# >&2 echo -e "github.sh pulls list $owner $repo closed $page | jq -M -r -c '.[] | { number , login: .user.login, from: .head.label, to: .base.label, state, created_at, closed_at, merged_at, repo: .head.repo.name, commends, review_comments, commits, additions, deletions, changed_file }  ' | sed 's/\"[^\"]\+\"://g;s/\"\?,\"\?/\t/g;s/^{//;s/}$//'"

#   github.sh pulls list $owner $repo closed $page   | jsonv number,user.login,head.label,base.label,state,created_at,closed_at,merged_at,head.repo.name,comments,review_comments,commits,additions,deletions,changed_files | tr , "\t"
#   github.sh pulls list $owner $repo closed $page | jq -M -r -c '.[] | { number , login: .user.login, from: .head.label, to: .base.label, state, created_at, closed_at, merged_at, repo: .head.repo.name, comments, review_comments, commits, additions, deletions, changed_file }  ' | sed 's/\"[^\"]\+\"://g;s/\"\?,\"\?/\t/g;s/^{//;s/}$//'
   github.sh pulls list $owner $repo closed $page | jq -M -r -c '.[] | { number , login: .user.login, from: .head.label, to: .base.label, state, created_at, closed_at, merged_at, repo: .head.repo.name  }  ' | sed 's/\"[^\"]\+\"://g;s/\"\?,\"\?/\t/g;s/^{//;s/}$//'
 
}

function getPRStatsFromDetail { 

    local idPR=$1
    
    [ -z $idPR ] && echo "Error ... please specify the PullRequest ID !" && exit -1
    
#>&2 echo "Retrieving PR $idPR"

    local X=$( github.sh pulls get $owner $repo $idPR | grep "^  \"\(comments\"\|review_comments\"\|commits\"\|additions\|deletions\|changed_files\)" | sed "s/.*: //;s/ //g" ); 
    local A=$(echo $X); 
    
    echo "${A// }" | tr "," "\t" ;
    
}

IFS=$'\n'

>&2 echo "Retrieving Statistcs of the last 20 PullReques of the repo $owner/$repo"

for prLine in $(listPRsWithStats); do 
    
    idPR=$( echo $prLine | cut -f 1 )
    
    prStats=$( getPRStatsFromDetail $idPR)

    prLine=$(echo "$prLine" | sed -e "s/\t\+$//g;" )
    
    
    echo -e "$prLine\t$prStats"
    
    
done

>&2 echo "Done"
