# -*-Shell-script-*-
#

. ${BASH_SOURCE[0]%/*}/base.sh

task_list() {
  # http://developer.github.com/v3/pulls/#list-pull-requests
  local owner=$1 repo=$2 state=$3 page=$4 

  call_api -X GET \
    "$(base_uri)/repos/${owner}/${repo}/pulls?$(query_string \
    $(add_param state         string optional) \
    $(add_param page          string optional) \
  )"
}

task_search() {
  # 'https://api.github.com:443/search/issues?q=is:pr+state:open+repo:xx+head:feature/xxw'
  local owner=$1 repo=$2 state=$3 head=$4

  call_api -X GET \
    "$(base_uri)/search/issues?q=is:pr+state:${state:-open}+repo:$owner/$repo+head:$head"

}

task_diff() {
  # http://developer.github.com/v3/pulls/#get-a-single-pull-request
  local owner=$1 repo=$2 number=$3

  call_api -X GET \
   $(base_uri)/repos/${owner}/${repo}/pulls/${number}/files
}

task_get() {
  # http://developer.github.com/v3/pulls/#get-a-single-pull-request
  local owner=$1 repo=$2 number=$3

  call_api -X GET \
   $(base_uri)/repos/${owner}/${repo}/pulls/${number}
}

task_new() {
  # http://developer.github.com/v3/pulls/#create-a-pull-request
  local owner=$1 repo=$2

  call_api -X POST --data @- \
   $(base_uri)/repos/${owner}/${repo}/pulls <<-EOS
	{
	  "title": "${title}",
	  "body": "${body}",
	  "head": "${head}",
	  "base": "${base}"
	}
	EOS
}

task_update() {
  # http://developer.github.com/v3/pulls/#update-a-pull-request
  local owner=$1 repo=$2 number=$3

  call_api -X PATCH --data @- \
   $(base_uri)/repos/${owner}/${repo}/pulls/${number} <<-EOS
	{
	  "title": "${title}",
	  "body": "${body}",
	  "state": "${state}"
	}
	EOS
}


task_merge() {
  # http://developer.github.com/v3/pulls/#merge-a-pull-request-merge-buttontrade
  local owner=$1 repo=$2 number=$3

  call_api -X PUT --data @- \
   $(base_uri)/repos/${owner}/${repo}/pulls/${number}/merge <<-EOS
	{
	  "commit_message": "${commit_message}"
	}
	EOS
}
