# -*-Shell-script-*-
#

. ${BASH_SOURCE[0]%/*}/base.sh

task_list() {
  # http://developer.github.com/v3/repos/statuses/#list-statuses-for-a-specific-ref
  local owner=$1 type=$2 sort=$3 direction=$4

  local url="users/$owner/repos"
  [ -z $owner ] && url="user/repos"
  
  set -x
  
  call_api -X GET \
    "$(base_uri)/$url?$(query_string \
    $(add_param type         string optional) \
    $(add_param sort         string optional) \
    $(add_param direction         string optional) \
  )"
  
}

task_new() {
  # http://developer.github.com/v3/repos/statuses/#create-a-status
  local owner=$1 repo=$2 sha=$3

  call_api -X POST --data @- \
   $(base_uri)/repos/${owner}/${repo}/statuses/${sha} <<-EOS
	{
	  "state": "${state}",
	  "target_url": "${target_url}",
	  "description": "${description}"
	}
	EOS
}
